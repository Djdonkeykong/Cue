import SwiftUI

struct OnboardingWelcomeView: View {
    let onContinue: () -> Void
    var onSignIn: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(SkinTheme.primarySoft)
                        .frame(width: 108, height: 108)
                    Image(systemName: "drop.circle.fill")
                        .font(.system(size: 54))
                        .foregroundStyle(SkinTheme.primaryDeep)
                }

                VStack(spacing: 8) {
                    Text("Cue")
                        .font(.cue(.heading1))
                        .foregroundStyle(SkinTheme.primaryText)
                    Text("Din hud, endelig forstatt.")
                        .font(.skin(.title3))
                        .foregroundStyle(SkinTheme.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }

            Spacer()

            VStack(spacing: 20) {
                Text("Finn ut hva som faktisk trigger huden din - og hva du kan gjore med det.")
                    .font(.skin(.callout))
                    .foregroundStyle(SkinTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button("Kom i gang", action: onContinue)
                    .font(.skin(.body, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.black, in: Capsule())
                    .padding(.horizontal, 24)

                if let onSignIn {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundStyle(SkinTheme.secondaryText)
                        Button("Sign in") {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            onSignIn()
                        }
                        .foregroundStyle(SkinTheme.primaryDeep)
                        .fontWeight(.semibold)
                    }
                    .font(.skin(.subheadline))
                }
            }
            .padding(.bottom, 52)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
