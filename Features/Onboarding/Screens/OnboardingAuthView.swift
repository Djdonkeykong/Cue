import AuthenticationServices
import SwiftUI

struct OnboardingAuthView: View {
    @EnvironmentObject private var authManager: AuthManager
    var onBack: (() -> Void)? = nil
    var onSkip: (() -> Void)? = nil

    @State private var showEmailSignUp = false
    @State private var errorMessage: String? = nil
    @State private var loadingProvider: AuthProvider? = nil

    private enum AuthProvider { case apple, google, email }

    var body: some View {
        ZStack(alignment: .top) {
            SkinTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Save your progress")
                        .font(.cue(.heading1))
                        .foregroundStyle(SkinTheme.primaryText)

                    Text("Create an account to sync your data across devices and never lose your progress.")
                        .font(.skin(.body))
                        .foregroundStyle(SkinTheme.secondaryText)
                        .lineSpacing(3)

                    if let error = errorMessage {
                        Text(error)
                            .font(.skin(.caption))
                            .foregroundStyle(SkinTheme.dangerColor)
                            .padding(.top, 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 28)

                Spacer()

                VStack(spacing: 12) {
                    appleButton
                    googleButton
                    divider
                    emailButton
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }

            HStack {
                if let onBack {
                    BackButton(action: onBack)
                }
                Spacer()
                if let onSkip {
                    Button("Skip") { onSkip() }
                        .font(.skin(.footnote))
                        .foregroundStyle(SkinTheme.tertiaryText)
                        .padding(12)
                        .contentShape(Rectangle())
                        .padding(.trailing, 12)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showEmailSignUp) {
            EmailAuthView(isSignIn: false)
                .environmentObject(authManager)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(26)
        }
    }

    // MARK: - Buttons

    private var isAnyLoading: Bool { loadingProvider != nil }

    private var appleButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            signInWithApple()
        } label: {
            ZStack {
                if loadingProvider == .apple {
                    ProgressView().tint(.white)
                } else {
                    HStack(spacing: 10) {
                        Image(systemName: "apple.logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Continue with Apple")
                            .font(.skin(.body, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(SkinTheme.black)
            .clipShape(Capsule())
        }
        .disabled(isAnyLoading)
    }

    private var googleButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            signInWithGoogle()
        } label: {
            ZStack {
                if loadingProvider == .google {
                    ProgressView().tint(.black)
                } else {
                    HStack(spacing: 10) {
                        Image(systemName: "globe")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Continue with Google")
                            .font(.skin(.body, weight: .semibold))
                            .foregroundStyle(SkinTheme.black)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.white)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.primary.opacity(0.14), lineWidth: 1))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .disabled(isAnyLoading)
    }

    private var divider: some View {
        HStack(spacing: 12) {
            Rectangle().fill(Color.primary.opacity(0.12)).frame(height: 1)
            Text("or").font(.skin(.caption)).foregroundStyle(SkinTheme.secondaryText)
            Rectangle().fill(Color.primary.opacity(0.12)).frame(height: 1)
        }
    }

    private var emailButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showEmailSignUp = true
        } label: {
            HStack(spacing: 10) {
                if loadingProvider == .email {
                    ProgressView().tint(.white)
                } else {
                    Text("Use email instead")
                        .font(.skin(.body, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(SkinTheme.primaryDeep)
            .clipShape(Capsule())
        }
        .disabled(isAnyLoading)
    }

    // MARK: - Actions

    private func signInWithGoogle() {
        errorMessage = nil
        loadingProvider = .google
        Task {
            do {
                try await authManager.signInWithGoogle()
                loadingProvider = nil
            } catch let error as AuthError where error.isCancelled {
                loadingProvider = nil
            } catch {
                loadingProvider = nil
                errorMessage = error.localizedDescription
            }
        }
    }

    private func signInWithApple() {
        errorMessage = nil
        loadingProvider = .apple
        Task {
            do {
                try await authManager.signInWithApple()
                loadingProvider = nil
            } catch let error as AuthError where error.isCancelled {
                loadingProvider = nil
            } catch {
                loadingProvider = nil
                errorMessage = error.localizedDescription
            }
        }
    }
}
