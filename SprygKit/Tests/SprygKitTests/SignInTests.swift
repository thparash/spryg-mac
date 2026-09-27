import Foundation
import Testing
import SprygKit

@MainActor
struct SignInTests {
    @Test func signingInShowsTheUsersBrands() async throws {
        let session = Session(environment: .testing(
            transport: ReplayTransport(routes: [
                "POST /users/login/": .fixture("login-success"),
            ])
        ))

        try await session.signIn(email: "pat@example.com", password: "correct horse")

        let user = try #require(session.user)
        #expect(user.email == "pat@example.com")
        #expect(user.isSuperuser == false)
        #expect(user.brands.map(\.name) == ["Northwind Naturals", "Acme Outdoors UK"])
        #expect(user.brands.first?.domain == "northwind.api.spryg.io")
    }

    @Test func aWrongPasswordIsReportedAndLeavesTheUserSignedOut() async throws {
        let session = Session(environment: .testing(
            transport: ReplayTransport(routes: [
                "POST /users/login/": .fixture("login-invalid-credentials", status: 401),
            ])
        ))

        await #expect(throws: SignInError.invalidCredentials) {
            try await session.signIn(email: "pat@example.com", password: "wrong")
        }
        #expect(session.user == nil)
    }

    @Test func signingInWithoutANetworkReportsThatTheServerCantBeReached() async throws {
        let session = Session(environment: .testing(transport: UnreachableTransport()))

        await #expect(throws: SignInError.unreachable) {
            try await session.signIn(email: "pat@example.com", password: "correct horse")
        }
        #expect(session.user == nil)
    }

    @Test func aServerFailureIsReportedWithItsStatus() async throws {
        let session = Session(environment: .testing(
            transport: ReplayTransport(routes: [
                "POST /users/login/": ReplayTransport.Response(status: 503, body: Data()),
            ])
        ))

        await #expect(throws: SignInError.server(status: 503)) {
            try await session.signIn(email: "pat@example.com", password: "correct horse")
        }
    }

    @Test func signInPostsTheCredentialsToTheConfiguredGlobalAPI() async throws {
        let transport = RecordingTransport(ReplayTransport(routes: [
            "POST /users/login/": .fixture("login-success"),
        ]))
        let staging = URL(string: "https://staging-global.api.spryg.io")!
        let session = Session(environment: .testing(transport: transport, globalAPI: staging))

        try await session.signIn(email: "pat@example.com", password: "correct horse")

        let request = try #require(transport.requests.first)
        #expect(request.httpMethod == "POST")
        #expect(request.url?.absoluteString == "https://staging-global.api.spryg.io/users/login/")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        let body = try JSONDecoder().decode([String: String].self, from: try #require(request.httpBody))
        #expect(body == ["email": "pat@example.com", "password": "correct horse"])
    }

    @Test func aResponseThatIsntALoginIsReportedAsUnexpected() async throws {
        let session = Session(environment: .testing(
            transport: ReplayTransport(routes: [
                "POST /users/login/": .fixture("login-malformed"),
            ])
        ))

        await #expect(throws: SignInError.unexpectedResponse) {
            try await session.signIn(email: "pat@example.com", password: "correct horse")
        }
        #expect(session.user == nil)
    }
}
