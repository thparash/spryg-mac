import Foundation
import Testing
import SprygKit

@MainActor
struct SessionPersistenceTests {
    let transport = ReplayTransport(routes: [
        "POST /users/login/": .fixture("login-success"),
    ])

    @Test func aSignedInUserIsStillSignedInAfterRelaunch() async throws {
        let store = InMemorySessionStore()
        try await Session(environment: .testing(transport: transport, sessionStore: store))
            .signIn(email: "pat@example.com", password: "correct horse")

        let relaunched = Session(environment: .testing(transport: transport, sessionStore: store))

        #expect(relaunched.user?.email == "pat@example.com")
        #expect(relaunched.user?.brands.count == 2)
    }

    @Test func onlyTokensAreStoredNeverThePassword() async throws {
        let store = InMemorySessionStore()
        try await Session(environment: .testing(transport: transport, sessionStore: store))
            .signIn(email: "pat@example.com", password: "correct horse")

        let stored = try #require(try store.load())
        #expect(stored.accessToken == "fixture-access-token")
        #expect(stored.refreshToken == "fixture-refresh-token")
        let encoded = String(decoding: try JSONEncoder().encode(stored), as: UTF8.self)
        #expect(!encoded.contains("correct horse"))
    }

    @Test func signingOutForgetsTheSessionAcrossRelaunch() async throws {
        let store = InMemorySessionStore()
        let session = Session(environment: .testing(transport: transport, sessionStore: store))
        try await session.signIn(email: "pat@example.com", password: "correct horse")

        try session.signOut()

        #expect(session.user == nil)
        #expect(try store.load() == nil)
        #expect(Session(environment: .testing(transport: transport, sessionStore: store)).user == nil)
    }

    @Test func signingOutReportsWhenTheStoredSessionCantBeRemoved() async throws {
        let session = Session(environment: .testing(transport: transport, sessionStore: UndeletableSessionStore()))
        try await session.signIn(email: "pat@example.com", password: "correct horse")

        #expect(throws: (any Error).self) { try session.signOut() }
    }
}
