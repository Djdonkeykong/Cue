import SwiftUI

private struct Testimonial {
    let name: String
    let ageLabel: String
    let text: String
}

private let testimonials: [Testimonial] = [
    .init(
        name: "Marte K.",
        ageLabel: "24",
        text: "After 3 months with Cue I finally know what triggers my skin. Dairy and poor sleep were the culprits!"
    ),
    .init(
        name: "Jonas A.",
        ageLabel: "29",
        text: "The ingredient scanner is worth its weight in gold. Found out my moisturizer had high comedogenic content."
    ),
    .init(
        name: "Sara L.",
        ageLabel: "22",
        text: "Love that the app spots the connection between stress and breakouts. Now I can actually do something about it."
    ),
]

struct OnboardingSocialProofView: View {
    let onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Text("Join 50,000+ users")
                        .font(.skin(.title2, weight: .bold))
                        .foregroundStyle(SkinTheme.primaryText)
                        .multilineTextAlignment(.center)
                    Text("who've discovered what's affecting their skin")
                        .font(.skin(.callout))
                        .foregroundStyle(SkinTheme.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 28)
                .padding(.horizontal, 24)

                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundStyle(SkinTheme.warningColor)
                    }
                    Text("4.8")
                        .font(.skin(.callout, weight: .bold))
                        .foregroundStyle(SkinTheme.primaryText)
                    Text("(2,300+ reviews)")
                        .font(.skin(.callout))
                        .foregroundStyle(SkinTheme.secondaryText)
                }

                VStack(spacing: 10) {
                    ForEach(testimonials, id: \.name) { t in
                        TestimonialCard(testimonial: t)
                    }
                }
                .padding(.horizontal, 24)

                VStack(spacing: 10) {
                    resultRow(icon: "checkmark.circle.fill", text: "Average 62% improvement after 30 days")
                    resultRow(icon: "checkmark.circle.fill", text: "9 out of 10 find their main trigger within 2 weeks")
                    resultRow(icon: "checkmark.circle.fill", text: "Recommended by over 200 dermatologists")
                }
                .padding(.horizontal, 24)

                Button("See my results", action: onContinue)
                    .font(.skin(.body, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(SkinTheme.accent, in: Capsule())
                    .padding(.horizontal, 24)
                    .padding(.bottom, 36)
            }
        }
    }

    @ViewBuilder
    private func resultRow(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(SkinTheme.safeColor)
                .frame(width: 20)
            Text(text)
                .font(.skin(.callout))
                .foregroundStyle(SkinTheme.primaryText)
            Spacer()
        }
    }
}

private struct TestimonialCard: View {
    let testimonial: Testimonial

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(SkinTheme.warningColor)
                }
                Spacer()
                Text("Age \(testimonial.ageLabel)")
                    .font(.skin(.caption))
                    .foregroundStyle(SkinTheme.tertiaryText)
            }
            Text(testimonial.text)
                .font(.skin(.callout))
                .foregroundStyle(SkinTheme.primaryText)
            Text("- " + testimonial.name)
                .font(.skin(.footnote, weight: .semibold))
                .foregroundStyle(SkinTheme.secondaryText)
        }
        .padding(16)
        .background(SkinTheme.surface, in: RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(SkinTheme.accent.opacity(0.12), lineWidth: 1)
        )
    }
}
