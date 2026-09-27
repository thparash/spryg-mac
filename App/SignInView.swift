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
        VStack(spacing: 16) {
            Text("Sign in to Spryg")
                .font(.title2.bold())

            Form {
                TextField("Email", text: $email)
                    .textContentType(.username)
                    .accessibilityIdentifier("signIn.email")
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .accessibilityIdentifier("signIn.password")
            }
            .formStyle(.columns)
            .onSubmit(signIn)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .accessibilityIdentifier("signIn.error")
            }

            Button(action: signIn) {
                if isSigningIn { ProgressView().controlSize(.small) } else { Text("Sign In") }
            }
            .keyboardShortcut(.defaultAction)
            .disabled(email.isEmpty || password.isEmpty || isSigningIn)
            .accessibilityIdentifier("signIn.submit")

            HStack(spacing: 16) {
                Button("Forgot password?") { openURL(SprygWebsite.forgotPassword) }
                Button("Create account") { openURL(SprygWebsite.createAccount) }
            }
            .buttonStyle(.link)
        }
        .padding(32)
        .frame(width: 380)
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
