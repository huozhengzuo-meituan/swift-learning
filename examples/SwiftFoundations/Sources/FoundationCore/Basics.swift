import Foundation

/// 第 2 课：先转换再除法，避免整数除法先丢失小数部分。
public func completionRatio(completed: Int, total: Int) -> Double {
    guard total > 0 else { return 0 }
    return Double(completed) / Double(total)
}

/// 第 3 课：按用户可感知的 Character 截取，而非 UTF-16 码元。
public func preview(_ title: String, limit: Int) -> String {
    let limit = max(0, limit)
    return title.count <= limit ? title : String(title.prefix(limit)) + "…"
}

/// 第 4 课：字典负责计数，输出时另行排序，不能依赖字典遍历顺序。
public func topicCounts(_ topics: [String]) -> [String: Int] {
    var counts: [String: Int] = [:]
    for topic in topics {
        counts[topic, default: 0] += 1
    }
    return counts
}

/// 第 5 课：nil 表示无有效输入；空白或超出范围同样不通过。
public func parseMinutes(_ input: String?) -> Int? {
    guard let input,
          let minutes = Int(input.trimmingCharacters(in: .whitespacesAndNewlines)),
          (1...180).contains(minutes) else { return nil }
    return minutes
}

/// 第 6 课：调用点读作 schedule("Swift", for: 25)。
public func schedule(_ title: String, for minutes: Int = 25) -> String {
    "\(title)：\(minutes) 分钟"
}

/// 调用处的 & 显式说明会更新传入的值。
public func add(_ minutes: Int, to total: inout Int) {
    total += minutes
}

/// 第 7 课：filter 保留元素，map 变换元素；这些闭包都立即执行。
public func searchableTitles(_ titles: [String], matching query: String) -> [String] {
    titles
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty && $0.localizedCaseInsensitiveContains(query) }
        .sorted()
}
