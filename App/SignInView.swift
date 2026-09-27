import SprygKit
import SwiftUI

struct SignInView: View {
    @Environment(Session.self) private var session
    @Environment(\.openURL) private var openURL

    @State private var email = ""
    @State private var password = ""
    @State private var isSigningIn = false
    @State private var errorMessage: String?

    var body: some View {
        HStack(spacing: 0) {
            form
                .frame(width: 400)
            Image("SignInArtwork")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 360)
                .clipped()
                // A clipped aspect-fill image still hit-tests at full size and would cover the form.
                .allowsHitTesting(false)
                .accessibilityHidden(true)
        }
        .frame(height: 520)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius))
        .sprygCard(padding: 0)
        .padding(32)
        .sprygPage()
    }

    private var form: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 44)
                .accessibilityLabel("Spryg")

            VStack(alignment: .leading, spacing: 4) {
                Text("Sign in")
                    .font(Theme.pageTitle)
                    .foregroundStyle(Theme.brand)
                Text("Amazon seller analytics for your Brands")
                    .foregroundStyle(Theme.textMuted)
            }

            VStack(alignment: .leading, spacing: 12) {
                TextField("Email", text: $email)
                    .textContentType(.username)
                    .accessibilityIdentifier("signIn.email")
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .accessibilityIdentifier("signIn.password")
            }
            .textFieldStyle(.roundedBorder)
            .controlSize(.large)
            .onSubmit(signIn)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(Theme.error)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("signIn.error")
            }

            Button(action: signIn) {
                Group {
                    if isSigningIn { ProgressView().controlSize(.small) } else { Text("Sign In") }
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .keyboardShortcut(.defaultAction)
            .disabled(email.isEmpty || password.isEmpty || isSigningIn)
            .accessibilityIdentifier("signIn.submit")

            HStack {
                Button("Forgot password?") { openURL(SprygWebsite.forgotPassword) }
                Spacer()
                Button("Create account") { openURL(SprygWebsite.createAccount) }
            }
            .buttonStyle(.link)
            .foregroundStyle(Theme.brandText)
        }
        .padding(40)
    }

    private func signIn() {
        guard !email.isEmpty, !password.isEmpty, !isSigningIn else { return }
        isSigningIn = true
        errorMessage = nil
        Task {
            defer { isSigningIn = false }
            do {
                try await session.signIn(email: email, password: password)
            } catch {
                errorMessage = message(for: error)
            }
        }
    }

    private func message(for error: Error) -> String {
        switch error as? SignInError {
        case .invalidCredentials: "That email and password don't match. Try again."
        case .unreachable: "Can't reach Spryg. Check your internet connection."
        case .server(let status): "Spryg couldn't sign you in (error \(status)). Try again later."
        case .unexpectedResponse: "Spryg sent a response the app doesn't understand. Try again later."
        case nil: "Something went wrong signing in. Try again."
        }
    }
}
