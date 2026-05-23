import SwiftUI

struct OnboardingResultsPreviewView: View {
    let vm: OnboardingViewModel
    let onContinue: () -> Void

    @State private var riskValue = 0
    @State private var triggersValue = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 6) {
                        Text("Your profile is ready")
                            .font(.cue(.heading2))
                            .foregroundStyle(SkinTheme.primaryText)
                        Text("We've analyzed your answers and found some important patterns.")
                            .font(.skin(.callout))
                            .foregroundStyle(SkinTheme.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .padding(.top, 24)

                    VStack(spacing: 12) {
                        ResultStatCard(
                            title: "Breakout risk",
                            value: "\(riskValue)%",
                            detail: "based on skin type and lifestyle",
                            color: vm.breakoutRiskPercent > 70 ? SkinTheme.dangerColor : SkinTheme.warningColor
                        )
                        ResultStatCard(
                            title: "Inflammation index",
                            value: vm.inflammationLabel,
                            detail: "based on severity",
                            color: vm.severity >= 4 ? SkinTheme.dangerColor : SkinTheme.warningColor
                        )
                        ResultStatCard(
                            title: "Triggers detected",
                            value: "\(triggersValue)+",
                            detail: "potential contributing factors",
                            color: SkinTheme.accent
                        )
                    }
                    .padding(.horizontal, 24)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Locked insights")
                            .font(.skin(.callout, weight: .semibold))
                            .foregroundStyle(SkinTheme.secondaryText)
                            .padding(.horizontal, 24)

                        VStack(spacing: 8) {
                            lockedRow("Top triggers for your skin")
                            lockedRow("Product conflict analysis")
                            lockedRow("Personalized 30-day plan")
                            lockedRow("Diet patterns and acne")
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 8)
            }

            PrimaryButton("Unlock all results", action: onContinue)
                .padding(.bottom, 36)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.4).delay(0.2)) {
                riskValue = vm.breakoutRiskPercent
                triggersValue = 2
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
        .background(SkinTheme.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
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
                .contentTransition(.numericText())
        }
        .padding(16)
        .background(SkinTheme.surface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}
