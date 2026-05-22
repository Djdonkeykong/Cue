import SwiftUI

private struct PainPoint {
    let icon: String
    let headline: String
    let body: String
}

private let painPoints: [PainPoint] = [
    .init(
        icon: "doc.questionmark.fill",
        headline: "You've tried everything",
        body: "Products, routines, advice from everywhere — but nothing gives lasting results. That's not your fault."
    ),
    .init(
        icon: "magnifyingglass.circle.fill",
        headline: "Your skin is unique",
        body: "What works for others won't necessarily work for you. Your skin reacts to its own set of triggers."
    ),
    .init(
        icon: "sparkles",
        headline: "We find the patterns for you",
        body: "Cue analyzes diet, stress, sleep, and products to find exactly what's affecting your skin."
    ),
]

struct OnboardingPainPointView: View {
    let onContinue: () -> Void
    @State private var currentIndex = 0

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentIndex) {
                ForEach(painPoints.indices, id: \.self) { i in
                    PainPointSlide(point: painPoints[i])
                        .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            VStack(spacing: 20) {
                HStack(spacing: 8) {
                    ForEach(painPoints.indices, id: \.self) { i in
                        Capsule()
                            .fill(i == currentIndex ? SkinTheme.accent : SkinTheme.accent.opacity(0.25))
                            .frame(width: i == currentIndex ? 20 : 8, height: 8)
                            .animation(.spring(duration: 0.3), value: currentIndex)
                    }
                }

                Button(currentIndex < painPoints.count - 1 ? "Next" : "Continue") {
                    if currentIndex < painPoints.count - 1 {
                        withAnimation { currentIndex += 1 }
                    } else {
                        onContinue()
                    }
                }
                .font(.skin(.body, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(SkinTheme.accent, in: Capsule())
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 52)
        }
    }
}

private struct PainPointSlide: View {
    let point: PainPoint

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                Circle()
                    .fill(SkinTheme.accentSoft)
                    .frame(width: 114, height: 114)
                Image(systemName: point.icon)
                    .font(.system(size: 48))
                    .foregroundStyle(SkinTheme.accent)
            }

            VStack(spacing: 12) {
                Text(point.headline)
                    .font(.skin(.title2, weight: .bold))
                    .foregroundStyle(SkinTheme.primaryText)
                    .multilineTextAlignment(.center)
                Text(point.body)
                    .font(.skin(.body))
                    .foregroundStyle(SkinTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
            }

            Spacer()
        }
    }
}
