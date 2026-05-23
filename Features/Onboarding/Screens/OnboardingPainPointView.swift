import SwiftUI

private struct PainPoint {
    let headline: String
    let body: String
}

private let painPoints: [PainPoint] = [
    .init(
        headline: "You've tried everything",
        body: "New products, strict routines, advice from everywhere — still breaking out."
    ),
    .init(
        headline: "It affects more than your skin",
        body: "Acne changes how you show up — in photos, at work, in social situations."
    ),
    .init(
        headline: "There's always a root cause",
        body: "Food, stress, sleep, and hidden ingredients in your products are usually the culprits."
    ),
    .init(
        headline: "You can figure it out",
        body: "Cue connects the dots between your lifestyle and your skin — so you finally know what to change."
    ),
]

struct OnboardingPainPointView: View {
    let onContinue: () -> Void
    @State private var currentIndex = 0

    private enum Slot { case a, b }
    @State private var slotA: Int = 0
    @State private var slotB: Int = 0
    @State private var slotAOffset: CGFloat = 0
    @State private var slotBOffset: CGFloat = 1
    @State private var slotAZIndex: Double = 1
    @State private var slotBZIndex: Double = 0
    @State private var activeSlot: Slot = .a

    var body: some View {
        VStack(spacing: 0) {
            // Content only — button and dots stay fixed below
            GeometryReader { geo in
                ZStack {
                    PainPointSlide(point: painPoints[slotA])
                        .offset(x: slotAOffset * geo.size.width)
                        .zIndex(slotAZIndex)

                    PainPointSlide(point: painPoints[slotB])
                        .offset(x: slotBOffset * geo.size.width)
                        .zIndex(slotBZIndex)
                }
                .clipped()
            }

            // Fixed chrome — never participates in slot transitions
            VStack(spacing: 20) {
                HStack(spacing: 8) {
                    ForEach(painPoints.indices, id: \.self) { i in
                        Capsule()
                            .fill(i == currentIndex ? SkinTheme.accent : SkinTheme.accent.opacity(0.25))
                            .frame(width: i == currentIndex ? 20 : 8, height: 8)
                            .animation(.spring(duration: 0.3), value: currentIndex)
                    }
                }

                PrimaryButton(currentIndex < painPoints.count - 1 ? "Next" : "Take the quiz") {
                    if currentIndex < painPoints.count - 1 {
                        advance()
                    } else {
                        onContinue()
                    }
                }
            }
            .padding(.bottom, 52)
            .padding(.top, 20)
        }
        .background(SkinTheme.background.ignoresSafeArea())
    }

    private func advance() {
        let next = currentIndex + 1
        let outgoing: Slot = activeSlot
        let incoming: Slot = activeSlot == .a ? .b : .a

        var snap = Transaction()
        snap.disablesAnimations = true
        withTransaction(snap) {
            switch incoming {
            case .a:
                slotA = next
                slotAOffset = 1
                slotAZIndex = 1
                slotBZIndex = 0
            case .b:
                slotB = next
                slotBOffset = 1
                slotBZIndex = 1
                slotAZIndex = 0
            }
        }

        activeSlot = incoming
        currentIndex = next

        withAnimation(.spring(response: 0.38, dampingFraction: 0.96)) {
            switch outgoing {
            case .a:
                slotAOffset = -1
                slotBOffset = 0
            case .b:
                slotBOffset = -1
                slotAOffset = 0
            }
        }
    }
}

private struct PainPointSlide: View {
    let point: PainPoint

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text(point.headline)
                .font(.cue(.heading2))
                .foregroundStyle(SkinTheme.primaryText)
                .multilineTextAlignment(.center)
            Text(point.body)
                .font(.skin(.body))
                .foregroundStyle(SkinTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}
