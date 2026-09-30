import Foundation
import Testing
import SprygKit

@MainActor
struct ActiveBrandTests {
    let transport = ReplayTransport(routes: [
        "POST /users/login/": .fixture("login-success"),
    ])

    @Test func onAFirstSignInTheActiveBrandIsTheFirstAlphabetically() async throws {
        let session = Session(environment: .testing(transport: transport))

        try await session.signIn(email: "pat@example.com", password: "correct horse")

        #expect(session.activeBrand?.name == "Acme Outdoors UK")
    }

    @Test func theChosenBrandIsStillActiveAfterRelaunch() async throws {
        let store = InMemorySessionStore()
        let session = Session(environment: .testing(transport: transport, sessionStore: store))
        try await session.signIn(email: "pat@example.com", password: "correct horse")
        let northwind = try #require(session.user?.brands.first { $0.name == "Northwind Naturals" })

        session.setActiveBrand(northwind)

        #expect(session.activeBrand == northwind)
        let relaunched = Session(environment: .testing(transport: transport, sessionStore: store))
        #expect(relaunched.activeBrand == northwind)
    }

    @Test func aRemovedBrandFallsBackToTheFirstAlphabetically() async throws {
        let store = InMemorySessionStore()
        try await Session(environment: .testing(transport: transport, sessionStore: store))
            .signIn(email: "pat@example.com", password: "correct horse")
        var stored = try #require(try store.load())
        stored.activeBrandID = 999  // a Brand this User was removed from
        try store.save(stored)

        let relaunched = Session(environment: .testing(transport: transport, sessionStore: store))

        #expect(relaunched.activeBrand?.name == "Acme Outdoors UK")
    }

    @Test func aBrandTheUserIsntAssignedCantBecomeActive() async throws {
        let session = Session(environment: .testing(transport: transport))
        try await session.signIn(email: "pat@example.com", password: "correct horse")
        let stranger = Brand(id: 404, name: "Someone Else's Brand", domain: "other.api.spryg.io", sellerID: nil, marketplace: nil)

        session.setActiveBrand(stranger)

        #expect(session.activeBrand?.name == "Acme Outdoors UK")
    }

    @Test func signingInAgainAsTheSameUserKeepsTheirActiveBrand() async throws {
        let store = InMemorySessionStore()
        let session = Session(environment: .testing(transport: transport, sessionStore: store))
        try await session.signIn(email: "pat@example.com", password: "correct horse")
        let northwind = try #require(session.user?.brands.first { $0.name == "Northwind Naturals" })
        session.setActiveBrand(northwind)

        try await session.signIn(email: "pat@example.com", password: "correct horse")

        #expect(session.activeBrand == northwind)
        #expect(Session(environment: .testing(transport: transport, sessionStore: store)).activeBrand == northwind)
    }

    @Test func signingOutForgetsTheActiveBrand() async throws {
        let store = InMemorySessionStore()
        let session = Session(environment: .testing(transport: transport, sessionStore: store))
        try await session.signIn(email: "pat@example.com", password: "correct horse")
        session.setActiveBrand(try #require(session.user?.brands.first { $0.name == "Northwind Naturals" }))

        try session.signOut()

        #expect(session.activeBrand == nil)
        try await session.signIn(email: "pat@example.com", password: "correct horse")
        #expect(session.activeBrand?.name == "Acme Outdoors UK")
    }
}
