import Foundation
import FoundationCore

@main
struct FoundationLab {
    static func main() throws {
        let argument = CommandLine.arguments.dropFirst().first ?? "all"
        let demos: [Int]
        if argument == "all" {
            demos = Array(1...14)
        } else if let number = Int(argument), (1...14).contains(number) {
            demos = [number]
        } else {
            print("用法：swift run foundation-lab [all|1...14]")
            throw LabError.invalidLesson(argument)
        }
        for number in demos {
            print("\n—— 第 \(number) 课 ——")
            try run(number)
        }
    }

    private static func run(_ number: Int) throws {
        switch number {
        case 1:
            print("SwiftPM -> FoundationCore -> foundation-lab")
            print("本包语言模式：Swift 6；最低 macOS：14")
        case 2:
            let completed = 2
            var total = 4
            total += 1
            print("\(completed)/\(total) = \(completionRatio(completed: completed, total: total))")
        case 3:
            let title = "👩🏽‍💻学习Swift"
            print("Character=\(title.count), UTF16=\(title.utf16.count)")
            print(preview(title, limit: 3))
        case 4:
            let topics = ["Swift", "UI", "Swift"]
            print("去重数：\(Set(topics).count)")
            for (topic, count) in topicCounts(topics).sorted(by: { $0.key < $1.key }) {
                print("\(topic)：\(count)")
            }
        case 5:
            for input in ["25", "0", "abc", nil] as [String?] {
                print("\(input ?? "nil") -> \(parseMinutes(input).map(String.init) ?? "无效")")
            }
        case 6:
            var total = 10
            add(25, to: &total)
            print(schedule("Swift"))
            print("累计 \(total) 分钟")
        case 7:
            print(searchableTitles([" swiftUI ", "UIKit", "Swift 6", ""], matching: "swift"))
        case 8:
            let original = StudySession(title: "值语义", minutes: 25)
            var copy = original
            copy.complete()
            print("原值：\(original.isCompleted)，副本：\(copy.isCompleted)")
            print(copy.label)
        case 9:
            let state = StudyState.active(title: "枚举", remainingMinutes: 12)
            print(state.message)
            if case let .active(_, remaining) = state { print("倒计时 \(remaining)") }
        case 10:
            let session = StudySession(title: "协议", minutes: 25)
            print(session.summary())
        case 11:
            print(unique(["Swift", "UI", "Swift"]))
            let readings: [any StudyDescribing] = [
                starterReading(), StudySession(title: "泛型", minutes: 30),
            ]
            print(summaries(readings).joined(separator: "\n"))
        case 12:
            let first = StudyCounter()
            let second = first
            second.increment()
            print("同一实例：\(first === second)，计数：\(first.count)")
            print("弱捕获后可释放：\(weakCaptureReleasesOwner())")
        case 13:
            let data = Data(#"[{"title":"Codable","minutes":25,"isCompleted":false}]"#.utf8)
            let sessions = try withCleanup({ try decodePlan(data) }, cleanup: { print("清理已执行") })
            print(String(decoding: try encodePlan(sessions), as: UTF8.self))
            do {
                _ = try decodePlan(Data(#"[{"title":"错误示例","minutes":0,"isCompleted":false}]"#.utf8))
            } catch let error as PlanError { print("预期的业务错误：\(error)") }
        case 14:
            var plan = StudyPlan(sessions: [
                StudySession(title: "Swift 语法", minutes: 25),
                StudySession(title: "SwiftUI 状态", minutes: 35),
            ])
            plan.complete(at: 0)
            print(plan.report)
            print("越界更新成功：\(plan.complete(at: 99))")
        default:
            break // main 已验证范围。
        }
    }
}

private enum LabError: Error { case invalidLesson(String) }
