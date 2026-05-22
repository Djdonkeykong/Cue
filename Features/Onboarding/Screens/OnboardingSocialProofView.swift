import SwiftUI

private struct Testimonial {
    let name: String
    let ageLabel: String
    let text: String
}

private let testimonials: [Testimonial] = [
    .init(
        name: "Marte K.",
        ageLabel: "24 ar",
        text: "Etter 3 maneder med Cue vet jeg endelig hva som trigger huden min. Meieri og darlig sovn var syndebukken!"
    ),
    .init(
        name: "Jonas A.",
        ageLabel: "29 ar",
        text: "Ingrediensskanneren er gull verdt. Fant ut at fuktighetskrem jeg brukte hadde hoyt komedogent innhold."
    ),
    .init(
        name: "Sara L.",
        ageLabel: "22 ar",
        text: "Elsker at appen ser sammenheng mellom stress og ubrudd. Na kan jeg faktisk gjore noe med det."
    ),
]

struct OnboardingSocialProofView: View {
    let onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Text("Bli med 50 000+ brukere")
                        .font(.skin(.title2, weight: .bold))
                        .foregroundStyle(SkinTheme.primaryText)
                        .multilineTextAlignment(.center)
                    Text("som har funnet ut hva som pavirker huden sin")
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
                    Text("(2 300+ anmeldelser)")
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
                    resultRow(icon: "checkmark.circle.fill", text: "Gjennomsnittlig 62% forbedring etter 30 dager")
                    resultRow(icon: "checkmark.circle.fill", text: "9 av 10 finner sin hoved-trigger innen 2 uker")
                    resultRow(icon: "checkmark.circle.fill", text: "Anbefalt av over 200 hudleger i Norden")
                }
                .padding(.horizontal, 24)

                Button("Se resultatene mine", action: onContinue)
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
                Text(testimonial.ageLabel)
                    .font(.skin(.caption1))
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
