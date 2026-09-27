import Foundation

/// A transport that answers from canned responses instead of the network.
/// Used by tests and by the app's fake-transport launch flag.
public struct ReplayTransport: HTTPTransport {
    public struct Response: Sendable {
        public let status: Int
        public let body: Data

        public init(status: Int, body: Data) {
            self.status = status
            self.body = body
        }

        /// A 200 response whose body is a bundled fixture, e.g. `login-success`.
        public static func fixture(_ name: String, status: Int = 200) -> Response {
            guard let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures"),
                  let data = try? Data(contentsOf: url)
            else { fatalError("Missing fixture \(name).json") }
            return Response(status: status, body: data)
        }
    }

    public struct NotReachable: Error {}

    private let routes: [String: Response]

    /// Routes are keyed "METHOD /path/", e.g. "POST /users/login/".
    public init(routes: [String: Response]) {
        self.routes = routes
    }

    public func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let key = "\(request.httpMethod ?? "GET") \(request.url?.path(percentEncoded: false) ?? "")"
        guard let response = routes[key], let url = request.url else { throw NotReachable() }
        let http = HTTPURLResponse(url: url, statusCode: response.status, httpVersion: nil, headerFields: nil)!
        return (response.body, http)
    }
}

extension SprygEnvironment {
    /// Recorded responses and throwaway storage, for UI tests. Nothing touches the network or the Keychain.
    public static func fixtures() -> SprygEnvironment {
        SprygEnvironment(
            globalAPI: productionGlobalAPI,
            transport: ReplayTransport(routes: [
                "POST /users/login/": .fixture("login-success"),
            ]),
            clock: SystemClock(),
            sessionStore: InMemorySessionStore(),
            cacheDirectory: FileManager.default.temporaryDirectory.appending(path: "SprygFixtures-\(UUID().uuidString)")
        )
    }
}
