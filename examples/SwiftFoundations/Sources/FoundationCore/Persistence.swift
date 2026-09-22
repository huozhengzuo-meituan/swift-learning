import Foundation

public enum PlanError: Error, Equatable {
    case emptyTitle
    case invalidMinutes(Int)
}

/// 第 13 课：解码成功只代表形状正确，业务约束还需要显式验证。
public func decodePlan(_ data: Data) throws -> [StudySession] {
    let sessions = try JSONDecoder().decode([StudySession].self, from: data)
    for session in sessions {
        guard !session.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw PlanError.emptyTitle
        }
        guard (1...180).contains(session.minutes) else {
            throw PlanError.invalidMinutes(session.minutes)
        }
    }
    return sessions
}

public func encodePlan(_ sessions: [StudySession]) throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    return try encoder.encode(sessions)
}

/// defer 保证离开作用域时执行清理；成功和抛错都覆盖。
/// 本例用回调让清理行为可测试，未操作用户文件。
public func withCleanup<Value>(
    _ operation: () throws -> Value,
    cleanup: () -> Void
) rethrows -> Value {
    defer { cleanup() }
    return try operation()
}
