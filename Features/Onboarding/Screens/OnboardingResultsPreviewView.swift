import SwiftUI

struct OnboardingResultsPreviewView: View {
    let vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 6) {
                    Text("Profilen din er klar")
                        .font(.skin(.title2, weight: .bold))
                        .foregroundStyle(SkinTheme.primaryText)
                    Text("Vi har analysert svarene dine og funnet noen viktige monster.")
                        .font(.skin(.callout))
                        .foregroundStyle(SkinTheme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .padding(.top, 24)

                VStack(spacing: 12) {
                    ResultStatCard(
                        title: "Breakout-risiko",
                        value: "\(vm.breakoutRiskPercent)%",
                        detail: "basert pa hudtype og livsstil",
                        color: vm.breakoutRiskPercent > 70 ? SkinTheme.dangerColor : SkinTheme.warningColor
                    )
                    ResultStatCard(
                        title: "Inflammasjonsindeks",
                        value: vm.inflammationLabel,
                        detail: "basert pa alvorlighetsgrad",
                        color: vm.severity >= 4 ? SkinTheme.dangerColor : SkinTheme.warningColor
                    )
                    ResultStatCard(
                        title: "Triggere oppdaget",
                        value: "\(max(vm.lifestyleFactors.count, 2))",
                        detail: "potensielle paveirkningsfaktorer",
                        color: SkinTheme.accent
                    )
                }
                .padding(.horizontal, 24)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Laaste innsikter")
                        .font(.skin(.callout, weight: .semibold))
                        .foregroundStyle(SkinTheme.secondaryText)
                        .padding(.horizontal, 24)

                    VStack(spacing: 8) {
                        lockedRow("Topptriggere for din hud")
                        lockedRow("Produktkonflikt-analyse")
                        lockedRow("Personlig 30-dagers plan")
                        lockedRow("Kostholdsmonster og akne")
                    }
                    .padding(.horizontal, 24)
                }

                Button("Las opp alle resultater", action: onContinue)
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
    private func lockedRow(_ title: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "lock.fill")
                .font(.callout)
                .foregroundStyle(SkinTheme.accent)
            Text(title)
                .font(.skin(.callout))
                .foregroundStyle(SkinTheme.secondaryText)
            Spacer()
        }
        .padding(14)
        .background(SkinTheme.surface, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(SkinTheme.accent.opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Stat card

private struct ResultStatCard: View {
    let title: String
    let value: String
    let detail: String
    let color: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.skin(.callout, weight: .semibold))
                    .foregroundStyle(SkinTheme.primaryText)
                Text(detail)
                    .font(.skin(.footnote))
                    .foregroundStyle(SkinTheme.secondaryText)
            }
            Spacer()
            Text(value)
                .font(.skin(.title2, weight: .bold))
                .foregroundStyle(color)
        }
        .padding(16)
        .background(SkinTheme.surface, in: RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}
