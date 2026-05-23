import SwiftUI

struct OnboardingRevealView: View {
    let onContinue: () -> Void

    @State private var displayedText = ""
    @State private var showButton = false

    private let fullText = "here's your personalized skin profile."

    var body: some View {
        ZStack {
            SkinTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Based on your answers,")
                        .font(.skin(.callout))
                        .foregroundStyle(SkinTheme.secondaryText)

                    Text(displayedText)
                        .font(.cue(.heading1))
                        .foregroundStyle(SkinTheme.primaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

                Spacer()

                PrimaryButton("Show me", action: onContinue)
                    .padding(.bottom, 36)
                    .opacity(showButton ? 1 : 0)
                    .animation(.easeIn(duration: 0.3), value: showButton)
            }
        }
        .task { await typeText() }
    }

    private func typeText() async {
        try? await Task.sleep(for: .milliseconds(300))
        for char in fullText {
            displayedText.append(char)
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            try? await Task.sleep(for: .milliseconds(38))
        }
        try? await Task.sleep(for: .milliseconds(400))
        showButton = true
    }
}
