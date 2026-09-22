/// 第 8 课：所有存储属性都是值；复制 StudySession 后修改副本不影响原值。
public struct StudySession: Equatable, Codable, Sendable {
    public let title: String
    public let minutes: Int
    public private(set) var isCompleted: Bool

    public init(title: String, minutes: Int, isCompleted: Bool = false) {
        self.title = title
        self.minutes = minutes
        self.isCompleted = isCompleted
    }

    // 从事实推导显示值，避免再存一份可能失去同步的 label。
    public var label: String { "\(title) · \(minutes) 分钟" }

    public mutating func complete() {
        isCompleted = true
    }
}

/// 第 9 课：每个状态只携带该状态需要的数据。
public enum StudyState: Equatable, Sendable {
    case idle
    case active(title: String, remainingMinutes: Int)
    case finished(completedCount: Int)

    public var message: String {
        switch self {
        case .idle:
            return "尚未开始"
        case let .active(title, remainingMinutes):
            return "\(title)：剩余 \(remainingMinutes) 分钟"
        case let .finished(completedCount):
            return "完成 \(completedCount) 项"
        }
    }
}

/// 第 10 课：声明调用者真正需要的能力，而不是强迫继承某个基类。
public protocol StudyDescribing {
    var studyTitle: String { get }
    var studyMinutes: Int { get }
    func summary() -> String
}

public extension StudyDescribing {
    func summary() -> String { "\(studyTitle)：\(studyMinutes) 分钟" }
}

extension StudySession: StudyDescribing {
    public var studyTitle: String { title }
    public var studyMinutes: Int { minutes }
}

public struct Reading: StudyDescribing {
    public let studyTitle: String
    public let studyMinutes: Int
    public init(title: String, minutes: Int) {
        studyTitle = title
        studyMinutes = minutes
    }
}

/// 第 11 课：泛型约束允许比较，并保留元素原本的类型。
public func unique<Element: Hashable>(_ elements: [Element]) -> [Element] {
    var seen: Set<Element> = []
    return elements.filter { seen.insert($0).inserted }
}

/// 调用者看见协议能力，但每次返回的底层类型仍固定为 Reading。
public func starterReading() -> some StudyDescribing {
    Reading(title: "The Swift Programming Language", minutes: 20)
}

/// 存在类型允许不同实现混放；这里有意只使用协议公开的能力。
public func summaries(_ items: [any StudyDescribing]) -> [String] {
    items.map { $0.summary() }
}
