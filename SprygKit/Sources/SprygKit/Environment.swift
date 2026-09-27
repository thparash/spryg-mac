import Foundation

/// Sends one HTTP request. The only boundary tests replace with recorded responses.
public protocol HTTPTransport: Sendable {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

/// The current time and time zone, so date rules can be tested with a fixed clock.
public protocol WallClock: Sendable {
    var now: Date { get }
    var timeZone: TimeZone { get }
}

/// What a signed-in session keeps between launches: tokens and the User, never the password.
public struct StoredSession: Equatable, Codable, Sendable {
    public let accessToken: String
    public let refreshToken: String?
    public let user: User

    public init(accessToken: String, refreshToken: String?, user: User) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.user = user
    }
}

/// Persists the StoredSession. The Keychain in production.
public protocol SessionStore: Sendable {
    func load() throws -> StoredSession?
    func save(_ session: StoredSession) throws
    func clear() throws
}

/// Everything SprygKit needs from the outside world.
public struct SprygEnvironment: Sendable {
    public var globalAPI: URL
    public var transport: any HTTPTransport
    public var clock: any WallClock
    public var sessionStore: any SessionStore
    public var cacheDirectory: URL

    public init(
        globalAPI: URL,
        transport: any HTTPTransport,
        clock: any WallClock,
        sessionStore: any SessionStore,
        cacheDirectory: URL
    ) {
        self.globalAPI = globalAPI
        self.transport = transport
        self.clock = clock
        self.sessionStore = sessionStore
        self.cacheDirectory = cacheDirectory
    }
}

extension SprygEnvironment {
    /// The production API. Release builds always use it.
    public static let productionGlobalAPI = URL(string: "https://global.api.spryg.io")!

    /// The global API to use. Only debug builds may override it, and only with an https URL.
    public static func globalAPI(override: String?, allowOverride: Bool) -> URL {
        guard allowOverride,
              let override,
              let url = URL(string: override),
              url.scheme == "https",
              url.host() != nil
        else { return productionGlobalAPI }
        return url
    }
}
