import SwiftUI
import StoreKit

struct OnboardingSocialProofView: View {
    let onContinue: () -> Void
    @Environment(\.requestReview) private var requestReview
    @State private var canContinue = false

    var body: some View {
        ZStack {
            SkinTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(SkinTheme.warningColor)
                        }
                    }

                    VStack(spacing: 8) {
                        Text("Enjoying Cue so far?")
                            .font(.cue(.heading1))
                            .foregroundStyle(SkinTheme.primaryText)
                            .multilineTextAlignment(.center)

                        Text("A quick rating helps others find us\nand keeps us motivated to improve.")
                            .font(.skin(.callout))
                            .foregroundStyle(SkinTheme.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                PrimaryButton("Continue", isEnabled: canContinue, action: onContinue)
                    .padding(.bottom, 36)
            }
        }
        .task {
            requestReview()
            try? await Task.sleep(for: .seconds(2))
            withAnimation { canContinue = true }
        }
    }
}
