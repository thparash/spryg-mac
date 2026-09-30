import Foundation
import Testing
import SprygKit

@MainActor
struct BrandRequestTests {
    let transport = ReplayTransport(routes: [
        "POST /users/login/": .fixture("login-success"),
    ])

    func signedInSession() async throws -> Session {
        let session = Session(environment: .testing(transport: transport))
        try await session.signIn(email: "pat@example.com", password: "correct horse")
        return session
    }

    @Test func aBrandRequestGoesToTheBrandsHostWithTheToken() async throws {
        let session = try await signedInSession()
        let northwind = try #require(session.user?.brands.first { $0.name == "Northwind Naturals" })

        let request = try session.brandRequest(path: "homepage/sales-metrics/", for: northwind)

        #expect(request.url?.absoluteString == "https://northwind.api.spryg.io/homepage/sales-metrics/")
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer fixture-access-token")
    }

    @Test(arguments: [
        "evil.example.com",
        "northwind.api.spryg.io.evil.example.com",
        "api.spryg.io",
        "north_wind.api.spryg.io",
        "NORTHWIND.API.SPRYG.IO",
        "northwind.api.spryg.io/../other",
    ])
    func theTokenIsNeverSentToAHostOutsideTheAllowlist(domain: String) async throws {
        let session = try await signedInSession()
        let brand = Brand(id: 12, name: "Tampered", domain: domain, sellerID: nil, marketplace: nil)

        #expect(throws: BrandRequestError.untrustedHost(domain)) {
            try session.brandRequest(path: "homepage/sales-metrics/", for: brand)
        }
    }

    @Test(arguments: [
        ("/homepage/sales-metrics/", "https://northwind.api.spryg.io/homepage/sales-metrics/"),
        ("@evil.example.com/steal/", "https://northwind.api.spryg.io/@evil.example.com/steal/"),
        ("//evil.example.com/steal/", "https://northwind.api.spryg.io/evil.example.com/steal/"),
    ])
    func thePathCanNeverMoveTheRequestOffTheBrandsHost(path: String, expected: String) async throws {
        let session = try await signedInSession()
        let northwind = try #require(session.user?.brands.first { $0.name == "Northwind Naturals" })

        let request = try session.brandRequest(path: path, for: northwind)

        #expect(request.url?.host() == "northwind.api.spryg.io")
        #expect(request.url?.absoluteString == expected)
    }

    @Test func aSignedOutSessionCantMakeBrandRequests() async throws {
        let session = try await signedInSession()
        let northwind = try #require(session.user?.brands.first)
        try session.signOut()

        #expect(throws: BrandRequestError.signedOut) {
            try session.brandRequest(path: "homepage/sales-metrics/", for: northwind)
        }
    }
}
