/// 第 14 课：CLI 和将来的 SwiftUI 可以复用这个不依赖 UI 的业务值。
public struct StudyPlan: Equatable, Sendable {
    public private(set) var sessions: [StudySession]

    public init(sessions: [StudySession]) {
        self.sessions = sessions
    }

    public var totalMinutes: Int { sessions.reduce(0) { $0 + $1.minutes } }
    public var completedCount: Int { sessions.filter(\.isCompleted).count }

    /// 完成指定位置的任务；位置不存在返回 false，不越界访问。
    @discardableResult
    public mutating func complete(at index: Int) -> Bool {
        guard sessions.indices.contains(index) else { return false }
        sessions[index].complete()
        return true
    }

    public var report: String {
        "计划 \(sessions.count) 项 · 共 \(totalMinutes) 分钟 · 已完成 \(completedCount) 项"
    }
}
