import SwiftUI

struct WelcomeView: View {
    let onContinue: () -> Void
    var onSignIn: (() -> Void)? = nil

    var body: some View {
        ZStack {
            SkinTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 8) {
                    Text("Cue")
                        .font(.cue(.heading1))
                        .foregroundStyle(SkinTheme.black)
                    Text("Your skin, finally understood.")
                        .font(.skin(.title3))
                        .foregroundStyle(SkinTheme.black.opacity(0.55))
                        .multilineTextAlignment(.center)
                }

                Spacer()

                VStack(spacing: 20) {
                    Text("Find out what's actually triggering your skin — and what to do about it.")
                        .font(.skin(.callout))
                        .foregroundStyle(SkinTheme.black.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    PrimaryButton("Get started", color: SkinTheme.black, action: onContinue)

                    if let onSignIn {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .foregroundStyle(SkinTheme.black.opacity(0.45))
                            Button("Sign in") {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                onSignIn()
                            }
                            .foregroundStyle(SkinTheme.black.opacity(0.75))
                            .fontWeight(.semibold)
                        }
                        .font(.skin(.subheadline))
                    }
                }
                .padding(.bottom, 52)
            }
        }
    }
}
