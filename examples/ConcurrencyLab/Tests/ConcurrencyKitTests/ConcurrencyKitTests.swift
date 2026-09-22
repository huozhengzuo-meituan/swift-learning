import ConcurrencyKit
import Foundation
import Testing

/// 测试门闩确定执行顺序，不靠“睡够几毫秒”猜测竞态。
private actor Gate {
    private var entered = false
    private var released = false
    private var entrants: [CheckedContinuation<Void, Never>] = []
    private var waiters: [CheckedContinuation<Void, Never>] = []
    func wait() async {
        entered = true
        let observers = entrants
        entrants.removeAll()
        observers.forEach { $0.resume() }
        guard !released else { return }
        await withCheckedContinuation { waiters.append($0) }
    }
    func waitUntilEntered() async {
        guard !entered else { return }
        await withCheckedContinuation { entrants.append($0) }
    }
    func open() {
        released = true
        let pending = waiters
        waiters.removeAll()
        pending.forEach { $0.resume() }
    }
}

private actor Flag {
    private var value = false
    func set() { value = true }
    func read() -> Bool { value }
}

private enum SampleError: Error, Equatable { case expected }
private let fixtureURL = URL(string: "https://example.invalid/profile")!

@Test func asyncLetCombinesIndependentResults() async throws {
    let result = try await loadDashboard()
    #expect(result.name == "林同学")
    #expect(result.unreadCount == 3)
}

@Test func groupPreservesInputOrderAndEmptyInput() async throws {
    let result = try await orderedMap([3, 1, 2]) { $0 * $0 }
    #expect(result == [9, 1, 4])
    #expect(try await orderedMap([]) { $0 } == [])
}

@Test func groupErrorCancelsAndJoinsSibling() async {
    let started = Gate()
    let cancelled = Flag()
    do {
        _ = try await orderedMap([1, 2]) { value in
            if value == 2 {
                await started.waitUntilEntered()
                throw SampleError.expected
            }
            // wait() announces entry before waiting; opening first makes it nonblocking.
            await started.open()
            await started.wait()
            do { try await Task.sleep(for: .seconds(30)) }
            catch is CancellationError {
                await cancelled.set()
                throw CancellationError()
            }
            return value
        }
        Issue.record("Expected the throwing child to fail the group")
    } catch {
        #expect(error as? SampleError == .expected)
    }
    // group 离开作用域时已等待 sibling 完成取消处理。
    #expect(await cancelled.read())
}

@Test func cancellationIsObservedByCPUWork() async {
    let gate = Gate()
    let task = Task {
        await gate.wait()
        return try await cancellableSum(upTo: 10_000)
    }
    await gate.waitUntilEntered()
    task.cancel()
    await gate.open()
    do {
        _ = try await task.value
        Issue.record("Expected cancellation")
    } catch { #expect(error is CancellationError) }
}

@Test func reservationMaintainsInvariantAcrossSuspension() async throws {
    let inventory = SeatInventory(capacity: 1)
    let gate = Gate()
    let first = Task { try await inventory.reserve { await gate.wait() } }
    await gate.waitUntilEntered()
    // 第一位仍在 await，但已经占位，第二位不能超售。
    #expect(await inventory.remaining() == 0)
    #expect(try await inventory.reserve {} == false)
    await gate.open()
    #expect(try await first.value)
    #expect(await inventory.remaining() == 0)
}

@Test func failedReservationRollsBack() async {
    let inventory = SeatInventory(capacity: 1)
    do {
        _ = try await inventory.reserve { throw SampleError.expected }
        Issue.record("Expected confirmation failure")
    } catch { #expect(error as? SampleError == .expected) }
    #expect(await inventory.remaining() == 1)
}

@Test func cancelledReservationRollsBack() async {
    let inventory = SeatInventory(capacity: 1)
    let gate = Gate()
    let task = Task { try await inventory.reserve { await gate.wait() } }
    await gate.waitUntilEntered()
    task.cancel()
    await gate.open()
    do { _ = try await task.value; Issue.record("Expected cancellation") }
    catch { #expect(error is CancellationError) }
    #expect(await inventory.remaining() == 1)
}

@Test func fixtureDecodesAndRejectsHTTPFailure() async throws {
    let client = ProfileClient(transport: FixtureTransport(json: #"{"id":7,"name":"林同学"}"#))
    #expect(try await client.fetch(from: fixtureURL) == ReaderProfile(id: 7, name: "林同学"))
    let failed = ProfileClient(transport: FixtureTransport(json: "not JSON", status: 503))
    do { _ = try await failed.fetch(from: fixtureURL); Issue.record("Expected HTTP error") }
    catch { #expect(error as? HTTPError == .unacceptableStatus(503)) }
}

@Test func fixtureRejectsNonHTTPAndDecodeFailure() async {
    let nonHTTP = ProfileClient(transport: FixtureTransport(json: "{}", status: nil))
    do { _ = try await nonHTTP.fetch(from: fixtureURL); Issue.record("Expected non-HTTP error") }
    catch { #expect(error as? HTTPError == .nonHTTPResponse) }
    let invalid = ProfileClient(transport: FixtureTransport(json: #"{"id":"wrong","name":"林"}"#))
    do { _ = try await invalid.fetch(from: fixtureURL); Issue.record("Expected decoding error") }
    catch { #expect(error is DecodingError) }
}

@Test @MainActor func olderResponseCannotReplaceNewerScreen() async {
    let model = ProfileScreenModel()
    let gate = Gate()
    let old = Task {
        await model.load {
            await gate.wait()
            return ReaderProfile(id: 1, name: "旧结果")
        }
    }
    await gate.waitUntilEntered()
    await model.load { ReaderProfile(id: 2, name: "新结果") }
    await gate.open()
    await old.value
    #expect(model.phase == .loaded(ReaderProfile(id: 2, name: "新结果")))
}

@Test func streamFinishesAndContinuationBridgesBothPaths() async throws {
    let feed = ProgressFeed(count: 3)
    var values: [Int] = []
    for await value in feed.stream { values.append(value) }
    await feed.waitUntilStopped()
    // bufferingNewest(1) 允许慢消费者漏掉中间状态，但最终状态必须保留。
    #expect(values.last == 3)
    #expect(values == values.sorted())
    #expect(try await bridgedTitle(succeeds: true) == "从回调到 async")
    do { _ = try await bridgedTitle(succeeds: false); Issue.record("Expected bridge failure") }
    catch { #expect(error as? LegacyFailure == .unavailable) }
}

@Test func consumerCancellationStopsProducerAndCallsTermination() async {
    let signal = AsyncStream<Bool>.makeStream(bufferingPolicy: .bufferingNewest(1))
    let feed = ProgressFeed(count: 1_000) {
        signal.continuation.yield(true)
        signal.continuation.finish()
    }
    let consumer = Task { for await _ in feed.stream {} }
    consumer.cancel()
    await consumer.value
    await feed.waitUntilStopped()
    var iterator = signal.stream.makeAsyncIterator()
    #expect(await iterator.next() == true)
}

@Test func explicitCloseSupportsEarlyBreak() async {
    let feed = ProgressFeed(count: 1_000)
    for await _ in feed.stream { break }
    feed.cancel()
    await feed.waitUntilStopped()
}

@Test func sendingTransfersDisconnectedDraft() async {
    let inbox = DraftInbox()
    let draft = Draft(title: "交接完成")
    await inbox.accept(draft)
    #expect(await inbox.title() == "交接完成")
}
