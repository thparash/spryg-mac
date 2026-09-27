import SprygKit
import SwiftUI

struct BrandListView: View {
    let user: User

    var body: some View {
        List(user.brands) { brand in
            Text(brand.name)
        }
        .accessibilityIdentifier("brandList")
        .safeAreaInset(edge: .top) {
            HStack {
                Text("Signed in as \(user.email)")
                if user.isSuperuser {
                    Text("Superuser")
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .background(.quaternary, in: Capsule())
                }
                Spacer()
            }
            .padding()
        }
        .frame(minWidth: 480, minHeight: 360)
    }
}
