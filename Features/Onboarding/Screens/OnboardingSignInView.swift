import SwiftUI

// Sign-in screen for returning users ("Welcome back").
struct OnboardingSignInView: View {
    @EnvironmentObject private var authManager: AuthManager
    var onBack: (() -> Void)? = nil
    var onSignUp: (() -> Void)? = nil

    @State private var showEmailSignIn = false
    @State private var errorMessage: String? = nil
    @State private var loadingProvider: AuthProvider? = nil

    private enum AuthProvider { case apple, google, email }

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                Spacer()

                // Illustration placeholder
                Color.clear
                    .frame(width: 320, height: 320)
                    .frame(maxWidth: .infinity)

                Spacer().frame(height: 36)

                VStack(alignment: .leading, spacing: 0) {
                    Text("Welcome back")
                        .font(.cue(.heading1))
                        .foregroundStyle(SkinTheme.primaryText)
                        .padding(.bottom, 10)

                    Text("Sign in to your account to pick up right where you left off.")
                        .font(.skin(.body))
                        .foregroundStyle(SkinTheme.secondaryText)
                        .lineSpacing(3)

                    if let error = errorMessage {
                        Text(error)
                            .font(.skin(.caption))
                            .foregroundStyle(SkinTheme.dangerColor)
                            .padding(.top, 8)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

                Spacer()

                VStack(spacing: 12) {
                    appleButton
                    googleButton
                    emailButton

                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundStyle(SkinTheme.secondaryText)
                        Button("Sign up") {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            onSignUp?()
                        }
                        .foregroundStyle(SkinTheme.primaryDeep)
                        .fontWeight(.semibold)
                    }
                    .font(.skin(.subheadline))
                    .padding(.top, 16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .padding(.top, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if let onBack {
                HStack {
                    BackButton(action: onBack)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.992, green: 0.910, blue: 0.949),
                    Color(red: 0.973, green: 0.894, blue: 0.949)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showEmailSignIn) {
            EmailAuthView(isSignIn: true)
                .environmentObject(authManager)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(26)
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

    private var emailButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showEmailSignIn = true
        } label: {
            Text("Continue with Email")
                .font(.skin(.body, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(SkinTheme.primaryDeep)
                .clipShape(Capsule())
        }
        .disabled(isAnyLoading)
    }

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

