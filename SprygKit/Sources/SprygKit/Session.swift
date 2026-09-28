import Foundation
import Observation

/// The signed-in state of the app: who the User is and how to reach the API as them.
@MainActor
@Observable
public final class Session {
    public private(set) var user: User?

    private let environment: SprygEnvironment

    public init(environment: SprygEnvironment) {
        self.environment = environment
        // An unreadable stored session is treated as signed out.
        user = (try? environment.sessionStore.load())?.user
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
        try environment.sessionStore.save(
            StoredSession(accessToken: login.access_token, refreshToken: login.refresh_token, user: login.user)
        )
        user = login.user
    }

    /// Signs out in this window even if the stored session can't be removed,
    /// then throws so the User can be told their sign-in may still be saved on this Mac.
    public func signOut() throws {
        user = nil
        try environment.sessionStore.clear()
    }
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
