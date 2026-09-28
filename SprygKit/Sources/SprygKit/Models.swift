import Foundation

/// One Amazon seller account in one Marketplace. See CONTEXT.md.
public struct Brand: Equatable, Hashable, Codable, Sendable, Identifiable {
    public let id: Int
    public let name: String
    /// Hostname of this Brand's own API, e.g. `northwind.api.spryg.io`.
    public let domain: String
    public let sellerID: String?
    /// Amazon marketplace ID, e.g. `ATVPDKIKX0DER` for the US.
    public let marketplace: String?

    public init(id: Int, name: String, domain: String, sellerID: String?, marketplace: String?) {
        self.id = id
        self.name = name
        self.domain = domain
        self.sellerID = sellerID
        self.marketplace = marketplace
    }
}

/// The signed-in person. A Superuser can also see Portfolios and cross-Brand views.
public struct User: Equatable, Codable, Sendable {
    public let email: String
    public let firstName: String?
    public let lastName: String?
    public let isSuperuser: Bool
    public let brands: [Brand]

    public init(email: String, firstName: String?, lastName: String?, isSuperuser: Bool, brands: [Brand]) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.isSuperuser = isSuperuser
        self.brands = brands
    }
}

extension User {
    /// The User's Brands, sorted by name the way Finder sorts.
    public var sortedBrands: [Brand] {
        brands.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }

    /// The User's Brands whose names contain `query`, ignoring case and accents, sorted by name.
    /// An empty query returns every Brand.
    public func brands(matching query: String) -> [Brand] {
        let query = query.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return sortedBrands }
        return sortedBrands.filter { $0.name.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil }
    }
}
