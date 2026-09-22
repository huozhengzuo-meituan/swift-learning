import Foundation
import Observation

struct ReadingResource: Identifiable, Sendable, Equatable {
    let id: String
    let title: String
    let url: URL
}

enum ResourceError: LocalizedError {
    case fixtureFailure
    var errorDescription: String? {
        String(localized: "This is a simulated loading failure. Turn it off in Settings and retry.")
    }
}

/// 确定性的离线 fixture，并非真实网络。async 不意味着这里需要后台线程。
protocol ResourceFetching: Sendable {
    func fetch(for topic: String, shouldFail: Bool) async throws -> [ReadingResource]
}

struct ResourceService: ResourceFetching {
    let delay: Duration
    init(delay: Duration = .milliseconds(500)) { self.delay = delay }

    func fetch(for topic: String, shouldFail: Bool) async throws -> [ReadingResource] {
        try await Task.sleep(for: delay) // 可取消的挂起点，不阻塞 MainActor。
        try Task.checkCancellation()
        if shouldFail { throw ResourceError.fixtureFailure }
        let isSwiftUI = topic.localizedCaseInsensitiveContains("ui")
        let path = isSwiftUI ? "swiftui" : "swift"
        // URL 来自固定的课程常量，而不是强制解包任意用户输入。
        guard let url = URL(string: "https://developer.apple.com/documentation/\(path)") else { return [] }
        return [ReadingResource(id: path, title: isSwiftUI ? "SwiftUI documentation" : "Swift documentation", url: url)]
    }
}

@MainActor
@Observable
final class ResourceLoader {
    enum State: Equatable {
        case idle, loading
        case loaded([ReadingResource])
        case failed(String)
    }
    private(set) var state: State = .idle
    private var generation = 0
    private let service: any ResourceFetching

    init(service: any ResourceFetching = ResourceService()) { self.service = service }

    func load(topic: String, shouldFail: Bool) async {
        // 已取消但尚未获调度的旧任务不得影响新请求的状态或代次。
        guard !Task.isCancelled else { return }
        generation += 1
        let request = generation
        state = .loading
        do {
            let resources = try await service.fetch(for: topic, shouldFail: shouldFail)
            // await 后仍须验证任务是否取消、结果是否属于当前请求。
            try Task.checkCancellation()
            guard request == generation else { return }
            state = .loaded(resources)
        } catch is CancellationError {
            // 用户切换条目不是业务错误；旧任务不能覆盖新任务的 loading。
            if request == generation { state = .idle }
        } catch {
            guard request == generation, !Task.isCancelled else { return }
            state = .failed(error.localizedDescription)
        }
    }
}
