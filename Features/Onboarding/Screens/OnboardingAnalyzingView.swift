import SwiftUI

struct OnboardingAnalyzingView: View {
    let onComplete: () -> Void

    @State private var progress: Double = 0

    private var statusMessage: String {
        switch progress {
        case ..<0.25: return "Reading your responses..."
        case ..<0.50: return "Identifying your triggers..."
        case ..<0.75: return "Building your skin profile..."
        default:      return "Almost done..."
        }
    }

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

                    Text("\(Int(progress * 100))%")
                        .font(.skin(.title, weight: .bold))
                        .foregroundStyle(SkinTheme.primaryText)
                        .monospacedDigit()
                }

                VStack(spacing: 8) {
                    Text("Calculating")
                        .font(.cue(.heading1))
                        .foregroundStyle(SkinTheme.primaryText)

                    Text(statusMessage)
                        .font(.skin(.callout))
                        .foregroundStyle(SkinTheme.secondaryText)
                        .animation(.easeInOut(duration: 0.4), value: statusMessage)
                }

                Spacer()
            }
        }
        .task { await runAnalysis() }
    }

    private func runAnalysis() async {
        withAnimation(.easeInOut(duration: 3.5)) { progress = 1.0 }
        try? await Task.sleep(for: .seconds(4.5))
        onComplete()
    }
}
