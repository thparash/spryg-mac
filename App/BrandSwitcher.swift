import SprygKit
import SwiftUI

/// Whether the Brand switcher is open. Shared so the ⌘K menu command can open it.
@MainActor
@Observable
final class BrandSwitcherState {
    var isPresented = false
}

/// Toolbar control that shows the Active Brand and opens the Brand picker.
/// ⌘K opens the picker too, through the "Switch Brand…" menu command.
struct BrandSwitcher: View {
    @Environment(BrandSwitcherState.self) private var state

    var body: some View {
        Button {
            state.isPresented = true
        } label: {
            // Icon only: the window title beside it already shows the Active Brand's name.
            Label("Switch Brand", systemImage: "chevron.up.chevron.down")
                .labelStyle(.iconOnly)
        }
        .help("Switch Brand (⌘K)")
        .accessibilityIdentifier("brandSwitcher")
    }
}

/// A sheet for choosing the Active Brand, like Xcode's Open Quickly. Shown as a sheet, not a
/// popover, because SwiftUI popovers anchored to toolbar buttons don't present on macOS.
struct BrandPicker: View {
    @Environment(Session.self) private var session
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Switch Brand")
                .font(Theme.cardTitle)
                .foregroundStyle(Theme.brandText)
            TextField("Search Brands", text: $query)
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("brandSwitcher.search")
                .onSubmit {
                    if let first = matches.first { choose(first) }
                }

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(matches) { brand in
                        BrandRow(brand: brand, isActive: brand == session.activeBrand, verticalPadding: 6) {
                            choose(brand)
                        }
                    }
                }
            }
            .frame(maxHeight: 320)

            if matches.isEmpty {
                Text("No Brands match \u{201C}\(query)\u{201D}")
                    .foregroundStyle(Theme.textMuted)
            }

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
            }
        }
        .padding(16)
        .frame(width: 340)
    }

    private func choose(_ brand: Brand) {
        session.setActiveBrand(brand)
        dismiss()
    }

    private var matches: [Brand] {
        session.user?.brands(matching: query) ?? []
    }
}

/// One Brand in a list. Clicking it makes it the Active Brand; the Active Brand shows a checkmark.
struct BrandRow: View {
    let brand: Brand
    let isActive: Bool
    let verticalPadding: CGFloat
    let choose: () -> Void

    var body: some View {
        Button(action: choose) {
            HStack {
                Text(brand.name)
                Spacer()
                if isActive {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Theme.brandText)
                }
            }
            .contentShape(Rectangle())
            .padding(.vertical, verticalPadding)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(brand.name)
        .accessibilityAddTraits(isActive ? .isSelected : [])
    }
}
