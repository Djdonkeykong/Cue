import SwiftUI
import RevenueCat

struct OnboardingPaywallView: View {
    let vm: OnboardingViewModel
    let onComplete: () -> Void

    @State private var offerings: Offerings?
    @State private var selectedPackage: Package?
    @State private var isPurchasing = false
    @State private var isRestoring = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack(alignment: .top) {
        ScrollView {
            VStack(spacing: 24) {
                header
                    .padding(.top, 28)

                featureList

                if let current = offerings?.current {
                    packagePicker(packages: current.availablePackages)
                } else if offerings == nil {
                    ProgressView()
                        .tint(SkinTheme.accent)
                        .padding(.vertical, 16)
                }

                if let msg = errorMessage {
                    Text(msg)
                        .font(.skin(.footnote))
                        .foregroundStyle(SkinTheme.dangerColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                actionButtons

                legalFooter
                    .padding(.bottom, 36)
            }
        }
        .contentMargins(.top, 72, for: .scrollContent)
        .contentMargins(.bottom, 160, for: .scrollContent)
        .scrollIndicators(.hidden)
        .task { await loadOfferings() }
        .overlay(alignment: .top) {
            LinearGradient(
                stops: [
                    .init(color: SkinTheme.background, location: 0),
                    .init(color: SkinTheme.background, location: 0.50),
                    .init(color: SkinTheme.background.opacity(0), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)
            .allowsHitTesting(false)
        }
        .overlay(alignment: .bottom) {
            LinearGradient(
                colors: [SkinTheme.background.opacity(0), SkinTheme.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 60)
            .ignoresSafeArea(edges: .bottom)
            .allowsHitTesting(false)
        }

            HStack {
                Spacer()
                Button("Skip") { onComplete() }
                    .font(.skin(.footnote))
                    .foregroundStyle(SkinTheme.tertiaryText)
                    .padding(12)
                    .contentShape(Rectangle())
                    .padding(.trailing, 12)
            }
            .padding(.top, 8)
        }
    }

    @ViewBuilder
    private var header: some View {
        VStack(spacing: 8) {
            Text("Unlock Cue Pro")
                .font(.cue(.heading1))
                .foregroundStyle(SkinTheme.primaryText)
            Text("Get access to all results and personalized tools")
                .font(.skin(.callout))
                .foregroundStyle(SkinTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }

    @ViewBuilder
    private var featureList: some View {
        VStack(spacing: 10) {
            featureRow(icon: "lock.open.fill",            text: "All locked results and analyses")
            featureRow(icon: "chart.line.uptrend.xyaxis", text: "Unlimited trigger tracking")
            featureRow(icon: "barcode.viewfinder",        text: "AI product scanning without limits")
            featureRow(icon: "brain.head.profile",        text: "Personalized AI recommendations")
            featureRow(icon: "bell.badge.fill",           text: "Smart alerts about your skin condition")
        }
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                purchase()
            } label: {
                Group {
                    if isPurchasing {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(purchaseButtonTitle)
                            .font(.skin(.body, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
            .background(
                selectedPackage != nil ? SkinTheme.accent : SkinTheme.accent.opacity(0.35),
                in: Capsule()
            )
            .disabled(selectedPackage == nil || isPurchasing)
            .padding(.horizontal, 24)

            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                onComplete()
            } label: {
                Text("Continue for free")
            }
                .font(.skin(.callout))
                .foregroundStyle(SkinTheme.secondaryText)

            Button("Restore purchases") {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                restore()
            }
                .font(.skin(.footnote))
                .foregroundStyle(SkinTheme.tertiaryText)
                .disabled(isRestoring)
        }
    }

    @ViewBuilder
    private var legalFooter: some View {
        Text("Subscription renews automatically. Cancel anytime in App Store settings. No refund for the current period.")
            .font(.skin(.caption2))
            .foregroundStyle(SkinTheme.tertiaryText)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
    }

    @ViewBuilder
    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(SkinTheme.accent)
                .frame(width: 22)
            Text(text)
                .font(.skin(.callout))
                .foregroundStyle(SkinTheme.primaryText)
            Spacer()
        }
    }

    @ViewBuilder
    private func packagePicker(packages: [Package]) -> some View {
        VStack(spacing: 10) {
            ForEach(packages, id: \.identifier) { pkg in
                PaywallPackageCard(
                    package: pkg,
                    isSelected: selectedPackage?.identifier == pkg.identifier
                ) {
                    selectedPackage = pkg
                }
            }
        }
        .padding(.horizontal, 24)
        .onAppear {
            if selectedPackage == nil {
                selectedPackage = packages.first { $0.packageType == .annual } ?? packages.first
            }
        }
    }

    private var purchaseButtonTitle: String {
        guard let pkg = selectedPackage else { return "Choose a plan" }
        switch pkg.packageType {
        case .weekly:  return "Start weekly — " + pkg.storeProduct.localizedPriceString
        case .monthly: return "Start monthly — " + pkg.storeProduct.localizedPriceString
        case .annual:  return "Start yearly — " + pkg.storeProduct.localizedPriceString
        default:       return "Start subscription"
        }
    }

    private func loadOfferings() async {
        do {
            offerings = try await Purchases.shared.offerings()
        } catch {
            errorMessage = "Could not load plans. Check your connection and try again."
        }
    }

    private func purchase() {
        guard let pkg = selectedPackage else { return }
        isPurchasing = true
        errorMessage = nil
        Task {
            do {
                let result = try await Purchases.shared.purchase(package: pkg)
                if !result.userCancelled { onComplete() }
            } catch {
                errorMessage = "Purchase failed. Please try again."
            }
            isPurchasing = false
        }
    }

    private func restore() {
        isRestoring = true
        errorMessage = nil
        Task {
            do {
                let info = try await Purchases.shared.restorePurchases()
                if info.entitlements.active.isEmpty {
                    errorMessage = "No active subscriptions found."
                } else {
                    onComplete()
                }
            } catch {
                errorMessage = "Restore failed. Please try again."
            }
            isRestoring = false
        }
    }
}

// MARK: - Package card

private struct PaywallPackageCard: View {
    let package: Package
    let isSelected: Bool
    let onSelect: () -> Void

    private var periodLabel: String {
        switch package.packageType {
        case .weekly:  return "Weekly"
        case .monthly: return "Monthly"
        case .annual:  return "Yearly"
        default:       return package.identifier
        }
    }

    private var isBestValue: Bool { package.packageType == .annual }

    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(periodLabel)
                            .font(.skin(.callout, weight: .semibold))
                            .foregroundStyle(isSelected ? .white : SkinTheme.primaryText)
                        if isBestValue {
                            Text("Best value")
                                .font(.skin(.caption2, weight: .bold))
                                .foregroundStyle(isSelected ? .white : SkinTheme.accent)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    isSelected ? Color.white.opacity(0.25) : SkinTheme.accentSoft,
                                    in: Capsule()
                                )
                        }
                    }
                    Text(package.storeProduct.localizedPriceString + " / " + periodLabel.lowercased())
                        .font(.skin(.footnote))
                        .foregroundStyle(isSelected ? .white.opacity(0.78) : SkinTheme.secondaryText)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? .white : SkinTheme.accent.opacity(0.35))
            }
            .padding(16)
            .background(
                isSelected ? SkinTheme.accent : SkinTheme.surface,
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(
                        isSelected ? Color.clear : (isBestValue ? SkinTheme.accent.opacity(0.4) : SkinTheme.accent.opacity(0.15)),
                        lineWidth: isBestValue && !isSelected ? 1.5 : 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
