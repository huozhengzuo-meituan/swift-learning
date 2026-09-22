import Foundation

public struct Dashboard: Equatable, Sendable {
    public let name: String
    public let unreadCount: Int
}

public func loadName() async throws -> String {
    // sleep 挂起当前任务，不阻塞线程；取消时抛出 CancellationError。
    try await Task.sleep(for: .milliseconds(2))
    return "林同学"
}

public func loadUnreadCount() async throws -> Int {
    try await Task.sleep(for: .milliseconds(1))
    return 3
}

public func loadDashboard() async throws -> Dashboard {
    // 两项相互独立，使用两个结构化子任务；它们不能越过当前作用域。
    async let name = loadName()
    async let count = loadUnreadCount()
    return try await Dashboard(name: name, unreadCount: count)
}

/// 子任务按完成顺序产生结果，索引负责还原调用者的输入顺序。
public func orderedMap(
    _ inputs: [Int],
    transform: @escaping @Sendable (Int) async throws -> Int
) async throws -> [Int] {
    try await withThrowingTaskGroup(of: (Int, Int).self) { group in
        for (index, input) in inputs.enumerated() {
            try Task.checkCancellation()
            group.addTask {
                try Task.checkCancellation()
                return (index, try await transform(input))
            }
        }
        // 只有父任务修改这个数组；不从多个子任务捕获并修改同一个 var。
        var indexed: [(Int, Int)] = []
        for try await result in group { indexed.append(result) }
        return indexed.sorted { $0.0 < $1.0 }.map(\.1)
    }
}

public func cancellableSum(upTo limit: Int) async throws -> Int {
    precondition(limit >= 0, "limit must be nonnegative")
    var sum = 0
    for value in 0..<limit {
        // CPU 循环需要主动检查；cancel() 不会强行打断循环。
        try Task.checkCancellation()
        sum += value
        if value.isMultiple(of: 100) { await Task.yield() }
    }
    try Task.checkCancellation()
    return sum
}

/// actor 防止数据竞争，但 await 之间仍可能插入其他调用。
public actor SeatInventory {
    private var available: Int

    public init(capacity: Int) {
        precondition(capacity >= 0)
        available = capacity
    }

    public func remaining() -> Int { available }

    public func reserve(
        confirm: @Sendable () async throws -> Void
    ) async throws -> Bool {
        try Task.checkCancellation()
        guard available > 0 else { return false }
        // 在第一次 await 前完成检查与占位，保持 available >= 0。
        available -= 1
        do {
            try await confirm()
            try Task.checkCancellation()
            return true
        } catch {
            // 这里只回滚内存占位；真实支付需要独立的幂等/补偿协议。
            available += 1
            throw error
        }
    }
}

public struct ReadingSnapshot: Sendable, Equatable {
    public let title: String
    public let minutes: Int
    public init(title: String, minutes: Int) {
        self.title = title
        self.minutes = minutes
    }
}

public func describe(
    _ snapshot: ReadingSnapshot,
    format: @Sendable (ReadingSnapshot) -> String
) -> String {
    format(snapshot)
}

// sending 自 Swift 6.0 起可用：转移一个断开连接的非 Sendable 值。
public final class Draft {
    public var title: String
    public init(title: String) { self.title = title }
}

public actor DraftInbox {
    private var draft: Draft?
    public init() {}
    public func accept(_ value: sending Draft) { draft = value }
    public func title() -> String? { draft?.title }
}
