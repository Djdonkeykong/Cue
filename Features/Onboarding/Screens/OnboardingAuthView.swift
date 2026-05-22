import AuthenticationServices
import SwiftUI

// Sign-up screen shown at the end of the onboarding flow (new users).
struct OnboardingAuthView: View {
    @EnvironmentObject private var authManager: AuthManager
    var onBack: (() -> Void)? = nil

    @State private var showEmailSignUp = false
    @State private var errorMessage: String? = nil
    @State private var loadingProvider: AuthProvider? = nil

    private enum AuthProvider { case apple, google, email }

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Illustration placeholder
                    Color.clear
                        .frame(height: 260)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 36)
                        .padding(.bottom, 12)

                    Text("Save your progress")
                        .font(.cue(.heading1))
                        .foregroundStyle(SkinTheme.primaryText)
                        .padding(.bottom, 10)

                    Text("Create an account to sync your data across devices and never lose your progress.")
                        .font(.skin(.body))
                        .foregroundStyle(SkinTheme.secondaryText)
                        .lineSpacing(3)
                        .padding(.bottom, 8)

                    if let error = errorMessage {
                        Text(error)
                            .font(.skin(.caption))
                            .foregroundStyle(SkinTheme.dangerColor)
                            .padding(.top, 6)
                    }

                    authButtons
                        .padding(.top, 32)
                }
                .padding(.horizontal, 24)
            }
            .contentMargins(.top, 16, for: .scrollContent)
            .contentMargins(.bottom, 80, for: .scrollContent)
            .scrollBounceBehavior(.always)
            .scrollIndicators(.hidden)
            .toolbar(.hidden, for: .navigationBar)

            // Fade the top edge into the background
            LinearGradient(
                stops: [
                    .init(color: SkinTheme.background, location: 0),
                    .init(color: SkinTheme.background, location: 0.30),
                    .init(color: SkinTheme.background.opacity(0), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(edges: .top)
            .allowsHitTesting(false)

            if let onBack {
                HStack {
                    BackButton(action: onBack)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
        .background(SkinTheme.background.ignoresSafeArea())
        .sheet(isPresented: $showEmailSignUp) {
            EmailAuthView(isSignIn: false)
                .environmentObject(authManager)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(26)
        }
    }

    // MARK: - Buttons

    private var authButtons: some View {
        VStack(spacing: 12) {
            appleButton
            googleButton
            divider
            emailButton
        }
    }

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
            .background(Color.black)
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
                        // Replace with Image("GoogleGLogo") once asset is added
                        Image(systemName: "globe")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Continue with Google")
                            .font(.skin(.body, weight: .semibold))
                            .foregroundStyle(Color.black)
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

