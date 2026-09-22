import Foundation
import SwiftData
import Testing
@testable import NativeStudy

@Suite("Draft validation and persistence")
@MainActor
struct StudyModelTests {
    private func container() throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true, cloudKitDatabase: .none)
        let container = try ModelContainer(for: StudyItem.self, configurations: configuration)
        container.mainContext.autosaveEnabled = false
        return container
    }

    @Test("Whitespace is invalid and does not insert an object")
    func rejectsEmptyTitle() throws {
        let container = try container()
        let context = container.mainContext
        #expect(throws: StudyValidationError.self) {
            try StudyWriter.save(StudyDraft(title: " \n "), editing: nil, in: context)
        }
        #expect(try context.fetchCount(FetchDescriptor<StudyItem>()) == 0)
    }

    @Test("Title count uses Swift characters, including emoji")
    func validatesBoundary() {
        #expect(StudyDraft(title: String(repeating: "🧑🏽‍💻", count: 80)).isValid)
        #expect(!StudyDraft(title: String(repeating: "🧑🏽‍💻", count: 81)).isValid)
        #expect(StudyDraft(title: "  SwiftUI\n").normalizedTitle == "SwiftUI")
    }

    @Test("Save, edit, complete and delete round trip through a fresh context")
    func lifecycle() throws {
        let container = try container()
        let context = container.mainContext
        let item = try StudyWriter.save(StudyDraft(title: "  SwiftUI  ", notes: "State"), editing: nil, in: context)
        let originalID = item.id
        try StudyWriter.save(StudyDraft(title: "Observation", notes: "MainActor"), editing: item, in: context)
        try StudyWriter.toggle(item, in: context)
        let reader = ModelContext(container)
        let saved = try #require(reader.fetch(FetchDescriptor<StudyItem>()).first)
        #expect(saved.id == originalID)
        #expect(saved.title == "Observation")
        #expect(saved.notes == "MainActor")
        #expect(saved.isCompleted)
        try StudyWriter.delete([item], in: context)
        #expect(try ModelContext(container).fetchCount(FetchDescriptor<StudyItem>()) == 0)
    }

    @Test("Deleting an item while its editor is open cannot report a successful save")
    func rejectsDeletedItem() throws {
        let container = try container()
        let context = container.mainContext
        let item = try StudyWriter.save(StudyDraft(title: "Original"), editing: nil, in: context)
        let draft = StudyDraft(title: "Unsaved editor changes")
        try StudyWriter.delete([item], in: context)
        #expect(throws: StudyValidationError.self) {
            try StudyWriter.save(draft, editing: item, in: context)
        }
        #expect(try context.fetchCount(FetchDescriptor<StudyItem>()) == 0)
        #expect(draft.title == "Unsaved editor changes")
    }

    @Test("Mutating a draft leaves the original model untouched")
    func cancelPreservesModel() throws {
        let container = try container()
        let context = container.mainContext
        let item = try StudyWriter.save(StudyDraft(title: "Original"), editing: nil, in: context)
        var draft = StudyDraft(title: item.title, notes: item.notes)
        draft.title = "Unsaved"
        #expect(item.title == "Original")
        #expect(!context.hasChanges)
    }
}

@Suite("Resource loading")
@MainActor
struct ResourceLoaderTests {
    @Test("Fixture success is deterministic")
    func success() async {
        let loader = ResourceLoader(service: ResourceService(delay: .zero))
        await loader.load(topic: "SwiftUI", shouldFail: false)
        guard case .loaded(let resources) = loader.state else {
            Issue.record("Expected resources to load")
            return
        }
        #expect(resources.map(\.id) == ["swiftui"])
    }

    @Test("Business errors are visible")
    func failure() async {
        let loader = ResourceLoader(service: ResourceService(delay: .zero))
        await loader.load(topic: "Swift", shouldFail: true)
        guard case .failed(let message) = loader.state else {
            Issue.record("Expected visible failure state")
            return
        }
        #expect(!message.isEmpty)
    }

    @Test("Cancellation is not displayed as a business error")
    func cancellation() async {
        let loader = ResourceLoader(service: ResourceService(delay: .seconds(10)))
        let task = Task { await loader.load(topic: "Swift", shouldFail: false) }
        task.cancel()
        await task.value
        #expect(loader.state == .idle)
    }

    @Test("A slow earlier result cannot overwrite a later request")
    func latestRequestWins() async {
        let service = ControlledResourceService()
        let loader = ResourceLoader(service: service)
        let old = Task { await loader.load(topic: "Swift", shouldFail: false) }
        await service.waitForRequest("Swift") // 明确等待旧任务进入服务，不猜调度顺序。
        let newest = Task { await loader.load(topic: "SwiftUI", shouldFail: false) }
        await service.waitForRequest("SwiftUI")
        await service.finish("SwiftUI")
        await newest.value
        await service.finish("Swift") // 故意逆序返回，并且不取消旧任务。
        await old.value
        guard case .loaded(let resources) = loader.state else {
            Issue.record("Expected latest successful request")
            return
        }
        #expect(resources.map(\.id) == ["SwiftUI"])
    }

    @Test("An already cancelled task cannot invalidate current state when it starts late")
    func cancelledBeforeStarting() async {
        let loader = ResourceLoader(service: ResourceService(delay: .zero))
        // 本测试与 Task 都属于 MainActor，取消发生在首次让出执行机会前。
        let old = Task { await loader.load(topic: "Swift", shouldFail: true) }
        old.cancel()
        await loader.load(topic: "SwiftUI", shouldFail: false)
        await old.value
        guard case .loaded(let resources) = loader.state else {
            Issue.record("A cancelled old task changed the current state")
            return
        }
        #expect(resources.map(\.id) == ["swiftui"])
    }
}

/// 测试控制返回顺序；故意不合作取消，用来证明 generation 防线独立有效。
private actor ControlledResourceService: ResourceFetching {
    private var pending: [String: CheckedContinuation<[ReadingResource], any Error>] = [:]
    private var waiting: [String: CheckedContinuation<Void, Never>] = [:]

    func fetch(for topic: String, shouldFail: Bool) async throws -> [ReadingResource] {
        try await withCheckedThrowingContinuation { continuation in
            pending[topic] = continuation
            waiting.removeValue(forKey: topic)?.resume()
        }
    }

    func waitForRequest(_ topic: String) async {
        if pending[topic] != nil { return }
        await withCheckedContinuation { waiting[topic] = $0 }
    }

    func finish(_ topic: String) {
        guard let continuation = pending.removeValue(forKey: topic),
              let url = URL(string: "https://developer.apple.com/documentation/swift") else { return }
        continuation.resume(returning: [ReadingResource(id: topic, title: topic, url: url)])
    }
}
