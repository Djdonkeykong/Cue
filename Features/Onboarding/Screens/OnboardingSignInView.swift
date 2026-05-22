import SwiftUI

struct OnboardingSignInView: View {
    @EnvironmentObject private var authManager: AuthManager
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Text("Opprett din hudprofil")
                        .font(.skin(.title, weight: .bold))
                        .foregroundStyle(SkinTheme.primaryText)
                        .multilineTextAlignment(.center)
                    Text("Lagre fremgangen din og fa personlige anbefalinger pa alle enheter.")
                        .font(.skin(.callout))
                        .foregroundStyle(SkinTheme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                VStack(spacing: 12) {
                    featureRow(icon: "chart.line.uptrend.xyaxis", text: "Spor hudtrender over tid")
                    featureRow(icon: "bell.badge.fill",           text: "Smartvarsler ved monster")
                    featureRow(icon: "lock.shield.fill",          text: "Dataene dine er trygge")
                }
                .padding(.horizontal, 36)
            }

            Spacer()

            VStack(spacing: 16) {
                if let msg = errorMessage {
                    Text(msg)
                        .font(.skin(.footnote))
                        .foregroundStyle(SkinTheme.dangerColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                Button {
                    signIn()
                } label: {
                    HStack(spacing: 12) {
                        if isLoading {
                            ProgressView()
                                .tint(SkinTheme.primaryText)
                        } else {
                            Image(systemName: "globe")
                                .font(.body)
                            Text("Fortsett med Google")
                                .font(.skin(.body, weight: .semibold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                }
                .buttonStyle(.glass)
                .disabled(isLoading)
                .padding(.horizontal, 24)

                Text("Ved a fortsette godtar du var personvernpolicy og brukervilkar.")
                    .font(.skin(.caption1))
                    .foregroundStyle(SkinTheme.tertiaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
            }
            .padding(.bottom, 52)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(SkinTheme.accent)
                .frame(width: 24)
            Text(text)
                .font(.skin(.callout))
                .foregroundStyle(SkinTheme.primaryText)
            Spacer()
        }
    }

    private func signIn() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await authManager.signInWithGoogle()
            } catch {
                errorMessage = "Innlogging mislyktes. Proev igjen."
                isLoading = false
            }
        }
    }
}
