import SprygKit
import SwiftUI

struct BrandListView: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 28)
                .accessibilityLabel("Spryg")
            HStack(alignment: .firstTextBaseline) {
                Text("Your Brands")
                    .font(Theme.pageTitle)
                    .foregroundStyle(Theme.brand)
                Spacer()
                Text(user.email)
                    .foregroundStyle(Theme.textMuted)
                if user.isSuperuser {
                    Text("Superuser")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.brandText)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Theme.brand.opacity(0.15), in: Capsule())
                }
            }

            VStack(alignment: .leading, spacing: 0) {
                Text("\(user.brands.count) Brands")
                    .font(Theme.cardTitle)
                    .foregroundStyle(Theme.brandText)
                    .padding(.bottom, 12)
                ForEach(user.brands) { brand in
                    Text(brand.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 10)
                    if brand.id != user.brands.last?.id {
                        Divider().overlay(Theme.cardBorder)
                    }
                }
            }
            .sprygCard()
            .accessibilityIdentifier("brandList")
        }
        .padding(24)
        .scrollOnOverflow()
        .frame(minWidth: 560, minHeight: 420)
        .sprygPage()
    }
}

private extension View {
    /// Scrolls the whole page when a Superuser's Brand list is taller than the window.
    func scrollOnOverflow() -> some View {
        ScrollView { self }
    }
}
