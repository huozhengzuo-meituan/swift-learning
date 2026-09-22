import Observation

/// Observation 负责追踪读取，MainActor 负责 UI 状态隔离；两者职责不同。
/// 本例会话偏好不落盘。持久偏好可用 AppStorage，学习条目交给 SwiftData。
@MainActor
@Observable
final class StudyPreferences {
    var showCompleted = true
    var simulateResourceFailure = false
}
