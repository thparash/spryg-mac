import SprygKit
import SwiftUI

@main
struct SprygApp: App {
    @State private var session = Session(environment: AppEnvironment.make())
    @State private var brandSwitcher = BrandSwitcherState()

    var body: some Scene {
        Window("Spryg", id: "main") {
            RootView()
                .environment(session)
                .environment(brandSwitcher)
        }
        .commands {
            CommandGroup(before: .windowSize) {
                Button("Switch Brand…") { brandSwitcher.isPresented = true }
                    .keyboardShortcut("k", modifiers: .command)
                    .disabled(session.user == nil)
                Divider()
            }
            CommandGroup(after: .appSettings) {
                Button("Sign Out", action: signOut)
                    .disabled(session.user == nil)
            }
        }
    }

    private func signOut() {
        brandSwitcher.isPresented = false
        do {
            try session.signOut()
        } catch {
            let alert = NSAlert()
            alert.messageText = "Your sign-in may still be saved on this Mac"
            alert.informativeText = "Spryg couldn't remove it from the Keychain. You can delete the \"io.spryg.mac\" item in Keychain Access."
            alert.runModal()
        }
    }
}

enum AppEnvironment {
    /// Debug builds read two launch arguments (or `defaults write io.spryg.mac ...`):
    /// `-SprygUseFixtures YES` swaps in canned fixture responses, and
    /// `-SprygGlobalAPI https://...` points the app at another global API host.
    static func make() -> SprygEnvironment {
        let defaults = UserDefaults.standard
        #if DEBUG
        if defaults.bool(forKey: "SprygUseFixtures") { return .fixtures() }
        let allowOverride = true
        #else
        let allowOverride = false
        #endif
        let globalAPI = SprygEnvironment.globalAPI(
            override: defaults.string(forKey: "SprygGlobalAPI"),
            allowOverride: allowOverride
        )
        return .live(globalAPI: globalAPI, bundleIdentifier: Bundle.main.bundleIdentifier ?? "io.spryg.mac")
    }
}

struct RootView: View {
    @Environment(Session.self) private var session
    @Environment(BrandSwitcherState.self) private var brandSwitcherState

    var body: some View {
        @Bindable var brandSwitcher = brandSwitcherState
        if let user = session.user {
            BrandListView(user: user)
                .navigationTitle(session.activeBrand?.name ?? "Spryg")
                .toolbar {
                    ToolbarItem(placement: .navigation) { BrandSwitcher() }
                }
                .sheet(isPresented: $brandSwitcher.isPresented) { BrandPicker() }
        } else {
            SignInView()
        }
    }
}
