import Foundation
import Testing
import FoundationCore

@Test("完成比例保留小数，并处理空计划")
func ratio() {
    #expect(completionRatio(completed: 1, total: 4) == 0.25)
    #expect(completionRatio(completed: 0, total: 0) == 0)
}

@Test("Unicode 预览不会拆开组合 emoji")
func unicodePreview() {
    #expect(preview("👩🏽‍💻学习", limit: 1) == "👩🏽‍💻…")
    #expect(preview("学习", limit: 2) == "学习")
    #expect(preview("", limit: 1) == "")
}

@Test("分钟输入校验", arguments: ["0", "181", "abc", "", "-1"])
func rejectsMinutes(_ input: String) {
    #expect(parseMinutes(input) == nil)
}

@Test("nil、空白与有效边界")
func minutesBoundaries() {
    #expect(parseMinutes(nil) == nil)
    #expect(parseMinutes(" 25\n") == 25)
    #expect(parseMinutes("180") == 180)
}

@Test("集合计数与稳定去重")
func collections() {
    #expect(topicCounts(["UI", "UI", "Swift"]) == ["UI": 2, "Swift": 1])
    #expect(unique([3, 1, 3, 2, 1]) == [3, 1, 2])
}

@Test("搜索清理空白并忽略大小写")
func search() {
    #expect(searchableTitles([" swiftUI ", "UIKit", "Swift 6", ""], matching: "swift") == ["Swift 6", "swiftUI"])
}

@Test("修改结构体副本不改变原值")
func valueCopy() {
    let original = StudySession(title: "Swift", minutes: 25)
    var copy = original
    copy.complete()
    #expect(!original.isCompleted)
    #expect(copy.isCompleted)
}

@Test("异构协议值保留共同能力")
func descriptions() {
    let items: [any StudyDescribing] = [Reading(title: "阅读", minutes: 10), StudySession(title: "练习", minutes: 20)]
    #expect(summaries(items) == ["阅读：10 分钟", "练习：20 分钟"])
}

@Test("保留回调也不会保活弱捕获对象")
func ownership() {
    #expect(weakCaptureReleasesOwner())
}

@Test("编码再解码保持学习记录")
func roundTrip() throws {
    let sessions = [StudySession(title: "Swift", minutes: 25, isCompleted: true)]
    #expect(try decodePlan(encodePlan(sessions)) == sessions)
}

@Test("格式合法但业务非法的 JSON 被拒绝")
func invalidDomainData() {
    let data = Data(#"[{"title":"Swift","minutes":0,"isCompleted":false}]"#.utf8)
    #expect(throws: PlanError.invalidMinutes(0)) { try decodePlan(data) }
    let blankTitle = Data(#"[{"title":"  ","minutes":25,"isCompleted":false}]"#.utf8)
    #expect(throws: PlanError.emptyTitle) { try decodePlan(blankTitle) }
    #expect(throws: DecodingError.self) { try decodePlan(Data("{}".utf8)) }
}

@Test("defer 在成功和抛错时都执行")
func cleanup() throws {
    var count = 0
    let value = withCleanup({ 42 }, cleanup: { count += 1 })
    #expect(value == 42)
    #expect(count == 1)
    #expect(throws: PlanError.emptyTitle) {
        try withCleanup({ throw PlanError.emptyTitle }, cleanup: { count += 1 })
    }
    #expect(count == 2)
}

@Test("里程碑更新幂等且越界不改变计划")
func planMilestone() {
    var plan = StudyPlan(sessions: [StudySession(title: "A", minutes: 25), StudySession(title: "B", minutes: 35)])
    // 先执行变更，再断言结果；断言表达式保持只读，避免宏重写 mutating 调用。
    let first = plan.complete(at: 0)
    let repeated = plan.complete(at: 0)
    #expect(first)
    #expect(repeated)
    #expect(plan.completedCount == 1)
    let before = plan
    let negativeIndex = plan.complete(at: -1)
    let endIndex = plan.complete(at: 2)
    #expect(!negativeIndex)
    #expect(!endIndex)
    #expect(plan == before)
    #expect(plan.totalMinutes == 60)
    #expect(plan.report == "计划 2 项 · 共 60 分钟 · 已完成 1 项")
}
