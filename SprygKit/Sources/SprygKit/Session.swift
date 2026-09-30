import Foundation
import Observation

/// The signed-in state of the app: who the User is and how to reach the API as them.
@MainActor
@Observable
public final class Session {
    public private(set) var user: User?
    /// The one Brand the app is showing. Every screen except Command Center shows its data.
    public private(set) var activeBrand: Brand?

    private let environment: SprygEnvironment
    private var accessToken: String?

    public init(environment: SprygEnvironment) {
        self.environment = environment
        // An unreadable stored session is treated as signed out.
        let stored = try? environment.sessionStore.load()
        user = stored?.user
        accessToken = stored?.accessToken
        activeBrand = stored.flatMap(Self.restoredActiveBrand(from:))
    }

    public func signIn(email: String, password: String) async throws {
        var request = URLRequest(url: environment.globalAPI.appending(path: "users/login/"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONEncoder().encode(["email": email, "password": password])

        let data: Data
        let response: HTTPURLResponse
        do {
            (data, response) = try await environment.transport.send(request)
        } catch is URLError {
            throw SignInError.unreachable
        }
        // A 401 from the login endpoint means a wrong email or password, not an expired session.
        if response.statusCode == 401 { throw SignInError.invalidCredentials }
        guard (200..<300).contains(response.statusCode) else {
            throw SignInError.server(status: response.statusCode)
        }
        guard let login = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
            throw SignInError.unexpectedResponse
        }
        // Signing in again as the same User (say, after the session expired) keeps their Active Brand.
        let previous = try? environment.sessionStore.load()
        let keptBrandID = previous?.user.email.caseInsensitiveCompare(login.email) == .orderedSame
            ? previous?.activeBrandID : nil
        let stored = StoredSession(
            accessToken: login.access_token,
            refreshToken: login.refresh_token,
            user: login.user,
            activeBrandID: keptBrandID
        )
        try environment.sessionStore.save(stored)
        user = login.user
        accessToken = login.access_token
        activeBrand = Self.restoredActiveBrand(from: stored)
    }

    /// A request to one Brand's own API, carrying the User's token. The token is only ever
    /// attached for hosts matching `<name>.api.spryg.io`, because a Brand's `domain` comes
    /// from the API and a bad value must not leak the token elsewhere.
    public func brandRequest(path: String, for brand: Brand) throws -> URLRequest {
        guard let accessToken else { throw BrandRequestError.signedOut }
        guard brand.domain.wholeMatch(of: #/[a-z0-9-]+\.api\.spryg\.io/#) != nil else {
            throw BrandRequestError.untrustedHost(brand.domain)
        }
        var components = URLComponents()
        components.scheme = "https"
        components.host = brand.domain
        components.path = "/" + path.drop { $0 == "/" }
        // Check the final URL too, so nothing in `path` can move the request to another host.
        guard let url = components.url, url.host() == brand.domain else {
            throw BrandRequestError.untrustedHost(brand.domain)
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }

    /// Makes `brand` the Active Brand and remembers it for the next launch.
    /// A Brand that isn't assigned to the User is ignored. If it can't be remembered,
    /// the next launch falls back to the first Brand alphabetically.
    public func setActiveBrand(_ brand: Brand) {
        guard user?.brands.contains(brand) == true else { return }
        activeBrand = brand
        guard var stored = try? environment.sessionStore.load() else { return }
        stored.activeBrandID = brand.id
        try? environment.sessionStore.save(stored)
    }

    /// Signs out in this window even if the stored session can't be removed,
    /// then throws so the User can be told their sign-in may still be saved on this Mac.
    public func signOut() throws {
        user = nil
        activeBrand = nil
        accessToken = nil
        try environment.sessionStore.clear()
    }
}

extension Session {
    /// The remembered Brand if it's still assigned, otherwise the first alphabetically.
    private static func restoredActiveBrand(from stored: StoredSession) -> Brand? {
        stored.user.brands.first { $0.id == stored.activeBrandID } ?? stored.user.sortedBrands.first
    }
}

public enum BrandRequestError: Error, Equatable {
    case signedOut
    case untrustedHost(String)
}

public enum SignInError: Error, Equatable {
    case invalidCredentials
    case unreachable
    case server(status: Int)
    case unexpectedResponse
}

/// `POST /users/login/`. Keys measured against the live API by spryg-mobile.
private struct LoginResponse: Decodable {
    /// One Brand. The API calls it a tenant.
    struct BrandPayload: Decodable {
        let id: Int
        let name: String
        let domain: String
        let seller_id: String?
        let marketplace: String?
    }

    let access_token: String
    let refresh_token: String?
    let email: String
    let f_name: String?
    let l_name: String?
    let is_superuser: Bool
    let tenant: [BrandPayload]

    var user: User {
        User(
            email: email,
            firstName: f_name,
            lastName: l_name,
            isSuperuser: is_superuser,
            brands: tenant.map {
                Brand(id: $0.id, name: $0.name, domain: $0.domain, sellerID: $0.seller_id, marketplace: $0.marketplace)
            }
        )
    }
}
