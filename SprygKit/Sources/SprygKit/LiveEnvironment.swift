import Foundation
import Security

/// Sends requests with URLSession.
public struct URLSessionTransport: HTTPTransport {
    public struct NotHTTP: Error {}

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw NotHTTP() }
        return (data, http)
    }
}

/// The Mac's clock and time zone.
public struct SystemClock: WallClock {
    public init() {}
    public var now: Date { Date() }
    public var timeZone: TimeZone { .current }
}

/// Keeps the StoredSession as one generic-password item in the login Keychain.
public struct KeychainSessionStore: SessionStore {
    public struct KeychainError: Error, Equatable {
        public let status: OSStatus
    }

    private let service: String
    private let account = "session"

    public init(service: String) {
        self.service = service
    }

    public func load() throws -> StoredSession? {
        var query = baseQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess, let data = result as? Data else { throw KeychainError(status: status) }
        return try JSONDecoder().decode(StoredSession.self, from: data)
    }

    public func save(_ session: StoredSession) throws {
        let data = try JSONEncoder().encode(session)
        let update = SecItemUpdate(baseQuery as CFDictionary, [kSecValueData as String: data] as CFDictionary)
        if update == errSecSuccess { return }
        guard update == errSecItemNotFound else { throw KeychainError(status: update) }
        var add = baseQuery
        add[kSecValueData as String] = data
        add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        let status = SecItemAdd(add as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }

    public func clear() throws {
        let status = SecItemDelete(baseQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError(status: status) }
    }

    private var baseQuery: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
    }
}

extension SprygEnvironment {
    /// The production dependencies: URLSession, the system clock, the Keychain and Application Support.
    public static func live(globalAPI: URL, bundleIdentifier: String) -> SprygEnvironment {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return SprygEnvironment(
            globalAPI: globalAPI,
            transport: URLSessionTransport(),
            clock: SystemClock(),
            sessionStore: KeychainSessionStore(service: bundleIdentifier),
            cacheDirectory: support.appending(path: bundleIdentifier).appending(path: "Cache")
        )
    }
}

/// Pages on the Spryg website that the app opens instead of building natively.
public enum SprygWebsite {
    public static let createAccount = URL(string: "https://app.spryg.io/signup")!
    public static let forgotPassword = URL(string: "https://app.spryg.io/forgot-password")!
}
