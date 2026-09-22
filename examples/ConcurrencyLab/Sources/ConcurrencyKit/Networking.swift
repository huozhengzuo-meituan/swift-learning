import Foundation

public struct ReaderProfile: Codable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public init(id: Int, name: String) { self.id = id; self.name = name }
}

public enum HTTPError: Error, Equatable {
    case nonHTTPResponse
    case unacceptableStatus(Int)
}

public protocol HTTPTransport: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

public struct LiveTransport: HTTPTransport {
    private let session: URLSession
    public init(session: URLSession = .shared) { self.session = session }
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }
}

/// 固定响应，用于离线演示与确定性测试；不读取公网，也不访问用户数据。
public struct FixtureTransport: HTTPTransport {
    private let body: Data
    private let status: Int?
    public init(json: String, status: Int? = 200) {
        self.body = Data(json.utf8)
        self.status = status
    }
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try Task.checkCancellation()
        guard let url = request.url else { throw URLError(.badURL) }
        if let status {
            guard let response = HTTPURLResponse(
                url: url, statusCode: status, httpVersion: "HTTP/1.1", headerFields: nil
            ) else { throw URLError(.badServerResponse) }
            return (body, response)
        }
        return (body, URLResponse(url: url, mimeType: nil,
                                  expectedContentLength: body.count, textEncodingName: nil))
    }
}

public struct ProfileClient: Sendable {
    private let transport: any HTTPTransport
    public init(transport: any HTTPTransport) { self.transport = transport }
    public func fetch(from url: URL) async throws -> ReaderProfile {
        try Task.checkCancellation()
        let (data, response) = try await transport.data(for: URLRequest(url: url))
        try Task.checkCancellation()
        guard let response = response as? HTTPURLResponse else {
            throw HTTPError.nonHTTPResponse
        }
        guard (200..<300).contains(response.statusCode) else {
            throw HTTPError.unacceptableStatus(response.statusCode)
        }
        // 每次调用创建 decoder；无跨任务共享的可变 decoder 配置。
        // DecodingError 保留给调用者，区分格式错误与 HTTP/传输错误。
        return try JSONDecoder().decode(ReaderProfile.self, from: data)
    }
}

/// UI 状态的隔离边界。暂不使用 Observation，专注并发契约。
@MainActor
public final class ProfileScreenModel {
    public enum Phase: Equatable, Sendable {
        case idle, loading, loaded(ReaderProfile), failed(String)
    }
    public private(set) var phase: Phase = .idle
    private var revision: UInt = 0
    public init() {}

    public func load(using fetch: @Sendable () async throws -> ReaderProfile) async {
        revision &+= 1
        let requestRevision = revision
        phase = .loading
        do {
            let profile = try await fetch()
            try Task.checkCancellation()
            // await 期间新请求可能已开始；旧结果不得覆盖新界面。
            guard revision == requestRevision else { return }
            phase = .loaded(profile)
        } catch is CancellationError {
            guard revision == requestRevision else { return }
            phase = .idle
        } catch {
            guard revision == requestRevision else { return }
            // URLSession 取消也可能报告 URLError.cancelled。
            phase = Task.isCancelled ? .idle : .failed(String(describing: error))
        }
    }
}
