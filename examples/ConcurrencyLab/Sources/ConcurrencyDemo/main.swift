import ConcurrencyKit
import Foundation

@main
struct ConcurrencyDemo {
    static func main() async throws {
        let command = CommandLine.arguments.dropFirst().first ?? "all"
        let valid = ["all", "async", "children", "group", "cancel", "actor", "sendable", "mainactor", "network", "stream", "migration"]
        guard valid.contains(command) else {
            print("可用演示：\(valid.joined(separator: ", "))")
            throw URLError(.unsupportedURL)
        }
        if command == "all" || command == "async" {
            print("async:", try await loadName())
        }
        if command == "all" || command == "children" {
            print("children:", try await loadDashboard())
        }
        if command == "all" || command == "group" {
            let values = try await orderedMap([3, 1, 2]) { value in
                try await Task.sleep(for: .milliseconds(value))
                return value * value
            }
            print("group: input order ->", values)
        }
        if command == "all" || command == "cancel" {
            let task = Task { try await cancellableSum(upTo: 100_000) }
            task.cancel()
            do { print("cancel: completed", try await task.value) }
            catch is CancellationError { print("cancel: observed CancellationError") }
        }
        if command == "all" || command == "actor" {
            let seats = SeatInventory(capacity: 1)
            async let first = seats.reserve { try await Task.sleep(for: .milliseconds(2)) }
            async let second = seats.reserve { try await Task.sleep(for: .milliseconds(2)) }
            let results = try await [first, second]
            print("actor: successes", results.filter { $0 }.count, "remaining", await seats.remaining())
        }
        if command == "all" || command == "sendable" {
            let snapshot = ReadingSnapshot(title: "Swift", minutes: 25)
            let suffix = "分钟" // 捕获不可变 Sendable 值。
            print("sendable:", describe(snapshot) { "\($0.title) · \($0.minutes)\(suffix)" })
            let inbox = DraftInbox()
            let draft = Draft(title: "一次所有权交接")
            await inbox.accept(draft)
            // 不再使用 draft；这与把 Draft 宣称为 Sendable 完全不同。
            print("sending:", await inbox.title() ?? "")
        }
        let client = ProfileClient(transport: FixtureTransport(json: #"{"id":7,"name":"林同学"}"#))
        let url = URL(string: "https://example.invalid/profile")!
        if command == "all" || command == "mainactor" {
            let model = ProfileScreenModel()
            await model.load { try await client.fetch(from: url) }
            print("mainactor:", model.phase)
        }
        if command == "all" || command == "network" {
            print("network: fixture ->", try await client.fetch(from: url))
        }
        if command == "all" || command == "stream" {
            let feed = ProgressFeed(count: 3)
            for await value in feed.stream { print("stream:", value) }
            await feed.waitUntilStopped()
            print("continuation:", try await bridgedTitle(succeeds: true))
        }
        if command == "all" || command == "migration" {
            print("migration: tools 6.0, language mode 6, explicit MainActor; upcoming flags off")
        }
    }
}
