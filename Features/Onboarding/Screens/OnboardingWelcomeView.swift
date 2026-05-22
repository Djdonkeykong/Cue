import SwiftUI

struct OnboardingWelcomeView: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(SkinTheme.accentSoft)
                        .frame(width: 108, height: 108)
                    Image(systemName: "drop.circle.fill")
                        .font(.system(size: 54))
                        .foregroundStyle(SkinTheme.accent)
                }

                VStack(spacing: 8) {
                    Text("Cue")
                        .font(.skin(.largeTitle, weight: .bold))
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
                    .padding(.vertical, 16)
                    .background(SkinTheme.accent, in: Capsule())
                    .padding(.horizontal, 24)
            }
            .padding(.bottom, 52)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
