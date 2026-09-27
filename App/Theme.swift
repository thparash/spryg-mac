import SwiftUI

/// Spryg's brand, ported from the web dashboard (ADR 0002). Screens take colors, fonts and
/// card styling from here and nowhere else. Light and dark values live in Assets.xcassets
/// and follow the Mac's appearance setting.
///
/// Deliberate difference from the web app: its buttons put white text on the brand green
/// (#379f7e), which is 3.3:1 and fails WCAG AA. Here buttons and small green text use the
/// web app's own darker green (#2a7d61, 5:1), and the brand green is kept for large titles
/// and accents, where 3:1 is enough.
enum Theme {
    // MARK: Colors

    /// Large titles, badges and accents.
    static let brand = Color("Brand")
    /// Small green text, such as card titles.
    static let brandText = Color("BrandText")
    static let pageBackground = Color("PageBackground")
    static let cardBackground = Color("CardBackground")
    static let cardBorder = Color("CardBorder")
    static let textMuted = Color("TextMuted")
    static let error = Color("Error")

    /// Chart series colors, assigned in this order and never cycled.
    /// Validated for color-vision deficiency on the card surface in both modes.
    static let chartSeries = [Color("ChartSeries1"), Color("ChartSeries2")]

    // MARK: Type

    /// The web dashboard renders in the system font (SF on a Mac), so the app does too.
    static let pageTitle = Font.system(size: 24, weight: .bold)
    static let cardTitle = Font.system(size: 16, weight: .semibold)

    // MARK: Shape

    static let cardRadius: CGFloat = 12
    static let controlRadius: CGFloat = 8
}

extension View {
    /// A white (or dark) rounded card with a hairline border and soft shadow, like the web dashboard's.
    func sprygCard(padding: CGFloat = 24) -> some View {
        self
            .padding(padding)
            .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cardRadius))
            .overlay(RoundedRectangle(cornerRadius: Theme.cardRadius).strokeBorder(Theme.cardBorder))
            .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
    }

    /// The page canvas behind every screen.
    func sprygPage() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.pageBackground.ignoresSafeArea())
    }
}
