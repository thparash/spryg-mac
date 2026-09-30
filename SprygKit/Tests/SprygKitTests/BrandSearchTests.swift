import Testing
import SprygKit

struct BrandSearchTests {
    let user = User(
        email: "pat@example.com", firstName: nil, lastName: nil, isSuperuser: true,
        brands: [
            Brand(id: 1, name: "Northwind Naturals", domain: "northwind.api.spryg.io", sellerID: nil, marketplace: nil),
            Brand(id: 2, name: "acme Outdoors UK", domain: "acmeuk.api.spryg.io", sellerID: nil, marketplace: nil),
            Brand(id: 3, name: "Café Olé", domain: "cafeole.api.spryg.io", sellerID: nil, marketplace: nil),
        ]
    )

    @Test func withNoSearchEveryBrandIsListedAlphabetically() {
        #expect(user.brands(matching: "").map(\.name) == ["acme Outdoors UK", "Café Olé", "Northwind Naturals"])
    }

    @Test(arguments: [("north", ["Northwind Naturals"]), ("ACME", ["acme Outdoors UK"]), ("cafe", ["Café Olé"]), ("zzz", [])])
    func searchNarrowsTheListIgnoringCaseAndAccents(query: String, expected: [String]) {
        #expect(user.brands(matching: query).map(\.name) == expected)
    }
}
