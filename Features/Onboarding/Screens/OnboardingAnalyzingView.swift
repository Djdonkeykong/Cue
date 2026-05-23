import SwiftUI

struct OnboardingAnalyzingView: View {
    let onComplete: () -> Void

    @State private var progress: Double = 0

    var body: some View {
        ZStack {
            SkinTheme.background.ignoresSafeArea()

            VStack(spacing: 44) {
                Spacer()

                ZStack {
                    Circle()
                        .stroke(SkinTheme.accent.opacity(0.12), lineWidth: 12)
                        .frame(width: 200, height: 200)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            SkinTheme.accent,
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.45), value: progress)

                    Text("\(Int(progress * 100))%")
                        .font(.skin(.title, weight: .bold))
                        .foregroundStyle(SkinTheme.primaryText)
                        .contentTransition(.numericText())
                }

                VStack(spacing: 8) {
                    Text("Calculating")
                        .font(.cue(.heading1))
                        .foregroundStyle(SkinTheme.primaryText)

                    Text("Understanding your responses")
                        .font(.skin(.callout))
                        .foregroundStyle(SkinTheme.secondaryText)
                }

                Spacer()
            }
        }
        .task { await runAnalysis() }
    }

    private func runAnalysis() async {
        let steps: [(TimeInterval, Double)] = [
            (0.30, 0.18),
            (0.55, 0.36),
            (0.55, 0.54),
            (0.55, 0.72),
            (0.55, 0.90),
            (0.50, 1.00),
        ]
        for (delay, prog) in steps {
            try? await Task.sleep(for: .seconds(delay))
            withAnimation { progress = prog }
        }
        try? await Task.sleep(for: .seconds(1.00))
        onComplete()
    }
}
