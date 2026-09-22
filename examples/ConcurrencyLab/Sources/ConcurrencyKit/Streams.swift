import Foundation

public struct ProgressFeed: Sendable {
    public let stream: AsyncStream<Int>
    private let producer: Task<Void, Never>

    public init(
        count: Int,
        onTermination: @escaping @Sendable () -> Void = {}
    ) {
        precondition(count >= 0)
        let pair = AsyncStream<Int>.makeStream(bufferingPolicy: .bufferingNewest(1))
        stream = pair.stream
        let producer = Task {
            defer { pair.continuation.finish() }
            do {
                for value in 1...max(1, count) {
                    guard count > 0 else { return }
                    try await Task.sleep(for: .milliseconds(2))
                    try Task.checkCancellation()
                    if case .terminated = pair.continuation.yield(value) { return }
                }
            } catch is CancellationError {
                // 预期的取消路径；defer 会结束流。
            } catch {
                // Task.sleep 当前只会因取消失败，其他错误留有可见诊断。
                assertionFailure("Unexpected progress error: \(error)")
            }
        }
        self.producer = producer
        pair.continuation.onTermination = { _ in
            producer.cancel()
            onTermination()
        }
    }

    /// 消费者提前 break 时显式关闭；不把 break 当成可靠的取消通知。
    public func cancel() { producer.cancel() }
    public func waitUntilStopped() async { await producer.value }
}

public enum LegacyFailure: Error, Equatable { case unavailable }

/// 模拟已明确保证“恰好回调一次”的旧 API。同步回调也是合法回调。
public func legacyTitle(
    succeeds: Bool,
    completion: @Sendable (Result<String, LegacyFailure>) -> Void
) {
    completion(succeeds ? .success("从回调到 async") : .failure(.unavailable))
}

public func bridgedTitle(succeeds: Bool) async throws -> String {
    try Task.checkCancellation()
    let title: String = try await withCheckedThrowingContinuation { continuation in
        legacyTitle(succeeds: succeeds) { result in
            // Result 合并成功/失败路径，保证此 API 的每条路径只 resume 一次。
            continuation.resume(with: result)
        }
    }
    try Task.checkCancellation()
    return title
}
