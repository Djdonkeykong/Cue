import SwiftUI

struct WelcomeView: View {
    let onContinue: () -> Void
    var onSignIn: (() -> Void)? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.996, green: 0.961, blue: 0.980),
                    Color(red: 0.973, green: 0.894, blue: 0.949)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 8) {
                    Text("Cue")
                        .font(.cue(.heading1))
                        .foregroundStyle(.black)
                    Text("Your skin, finally understood.")
                        .font(.skin(.title3))
                        .foregroundStyle(.black.opacity(0.55))
                        .multilineTextAlignment(.center)
                }

                Spacer()

                VStack(spacing: 20) {
                    Text("Find out what's actually triggering your skin — and what to do about it.")
                        .font(.skin(.callout))
                        .foregroundStyle(.black.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    PrimaryButton("Get started", color: .black, action: onContinue)

                    if let onSignIn {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .foregroundStyle(.black.opacity(0.45))
                            Button("Sign in") {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                onSignIn()
                            }
                            .foregroundStyle(.black.opacity(0.75))
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
