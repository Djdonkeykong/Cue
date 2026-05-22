import SwiftUI

struct OnboardingAnalyzingView: View {
    let onComplete: () -> Void

    @State private var progress: Double = 0
    @State private var statusIndex = 0

    private let statusMessages = [
        "Analyzing your answers...",
        "Mapping skin triggers...",
        "Calculating risk profile...",
        "Building your personal plan...",
        "Finalizing results...",
    ]

    var body: some View {
        ZStack {
            SkinTheme.background.ignoresSafeArea()

            VStack(spacing: 44) {
                Spacer()

                ZStack {
                    Circle()
                        .stroke(SkinTheme.accent.opacity(0.15), lineWidth: 10)
                        .frame(width: 148, height: 148)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            SkinTheme.accent,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .frame(width: 148, height: 148)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.45), value: progress)

                    VStack(spacing: 4) {
                        Text("\(Int(progress * 100))%")
                            .font(.skin(.title, weight: .bold))
                            .foregroundStyle(SkinTheme.accent)
                            .contentTransition(.numericText())
                        Text("complete")
                            .font(.skin(.caption))
                            .foregroundStyle(SkinTheme.secondaryText)
                    }
                }

                VStack(spacing: 10) {
                    Text("Analyzing your skin profile")
                        .font(.skin(.title3, weight: .bold))
                        .foregroundStyle(SkinTheme.primaryText)

                    Text(statusMessages[min(statusIndex, statusMessages.count - 1)])
                        .font(.skin(.callout))
                        .foregroundStyle(SkinTheme.secondaryText)
                        .animation(.easeInOut(duration: 0.3), value: statusIndex)
                        .id(statusIndex)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Spacer()
            }
        }
        .task { await runAnalysis() }
    }

    private func runAnalysis() async {
        let steps: [(TimeInterval, Double, Int)] = [
            (0.30, 0.18, 0),
            (0.55, 0.36, 1),
            (0.55, 0.54, 2),
            (0.55, 0.72, 3),
            (0.55, 0.90, 4),
            (0.50, 1.00, 4),
        ]
        for (delay, prog, status) in steps {
            try? await Task.sleep(for: .seconds(delay))
            withAnimation { progress = prog }
            statusIndex = status
        }
        try? await Task.sleep(for: .seconds(0.65))
        onComplete()
    }
}
