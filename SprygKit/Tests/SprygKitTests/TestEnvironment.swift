import Foundation
import SprygKit

struct FixedClock: WallClock {
    var now = Date(timeIntervalSince1970: 1_790_000_000)
    var timeZone = TimeZone(identifier: "America/Los_Angeles")!
}

extension SprygEnvironment {
    static func testing(
        transport: any HTTPTransport,
        sessionStore: any SessionStore = InMemorySessionStore(),
        globalAPI: URL = SprygEnvironment.productionGlobalAPI
    ) -> SprygEnvironment {
        SprygEnvironment(
            globalAPI: globalAPI,
            transport: transport,
            clock: FixedClock(),
            sessionStore: sessionStore,
            cacheDirectory: FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        )
    }
}

/// A transport whose every request fails like a dropped connection.
struct UnreachableTransport: HTTPTransport {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        throw URLError(.notConnectedToInternet)
    }
}

/// Wraps a transport and remembers every request sent through it.
final class RecordingTransport: HTTPTransport, @unchecked Sendable {
    private let inner: any HTTPTransport
    private let lock = NSLock()
    private var _requests: [URLRequest] = []
    var requests: [URLRequest] { lock.withLock { _requests } }

    init(_ inner: any HTTPTransport) { self.inner = inner }

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        lock.withLock { _requests.append(request) }
        return try await inner.send(request)
    }
}

/// A SessionStore whose Keychain delete fails, like a locked or denied Keychain.
final class UndeletableSessionStore: SessionStore, @unchecked Sendable {
    struct DeleteFailed: Error {}
    private let inner = InMemorySessionStore()
    func load() throws -> StoredSession? { try inner.load() }
    func save(_ session: StoredSession) throws { try inner.save(session) }
    func clear() throws { throw DeleteFailed() }
}
