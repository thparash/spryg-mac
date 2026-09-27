import Foundation

/// A SessionStore that lives only as long as the process. For tests and UI tests.
public final class InMemorySessionStore: SessionStore, @unchecked Sendable {
    private let lock = NSLock()
    private var session: StoredSession?

    public init(_ session: StoredSession? = nil) {
        self.session = session
    }

    public func load() throws -> StoredSession? {
        lock.withLock { session }
    }

    public func save(_ session: StoredSession) throws {
        lock.withLock { self.session = session }
    }

    public func clear() throws {
        lock.withLock { session = nil }
    }
}
