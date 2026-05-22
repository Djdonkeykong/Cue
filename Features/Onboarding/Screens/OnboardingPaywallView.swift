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
        .task { await loadOfferings() }
    }

    @ViewBuilder
    private var header: some View {
        VStack(spacing: 8) {
            Text("Las opp Cue Pro")
                .font(.skin(.title2, weight: .bold))
                .foregroundStyle(SkinTheme.primaryText)
            Text("Fa tilgang til alle resultater og personlige verktoy")
                .font(.skin(.callout))
                .foregroundStyle(SkinTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }

    @ViewBuilder
    private var featureList: some View {
        VStack(spacing: 10) {
            featureRow(icon: "lock.open.fill",            text: "Alle laaste resultater og analyser")
            featureRow(icon: "chart.line.uptrend.xyaxis", text: "Ubegrenset trigger-sporing")
            featureRow(icon: "barcode.viewfinder",        text: "AI-produktskanning uten begrensninger")
            featureRow(icon: "brain.head.profile",        text: "Personlige AI-anbefalinger")
            featureRow(icon: "bell.badge.fill",           text: "Smartvarsler om hudens tilstand")
        }
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
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

            Button("Fortsett gratis", action: onComplete)
                .font(.skin(.callout))
                .foregroundStyle(SkinTheme.secondaryText)

            Button("Gjenopprett kjoep") { restore() }
                .font(.skin(.footnote))
                .foregroundStyle(SkinTheme.tertiaryText)
                .disabled(isRestoring)
        }
    }

    @ViewBuilder
    private var legalFooter: some View {
        Text("Abonnementet fornyes automatisk. Avbryt nar som helst i App Store-innstillinger. Ingen refusjon for paganvaerende periode.")
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
        guard let pkg = selectedPackage else { return "Velg abonnement" }
        switch pkg.packageType {
        case .weekly:  return "Start ukentlig - " + pkg.storeProduct.localizedPriceString
        case .monthly: return "Start manedlig - " + pkg.storeProduct.localizedPriceString
        case .annual:  return "Start arlig - " + pkg.storeProduct.localizedPriceString
        default:       return "Start abonnement"
        }
    }

    private func loadOfferings() async {
        do {
            offerings = try await Purchases.shared.offerings()
        } catch {
            errorMessage = "Kunne ikke laste abonnementer. Sjekk internett og proev igjen."
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
                errorMessage = "Kjoep mislyktes. Proev igjen."
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
                    errorMessage = "Ingen aktive abonnementer funnet."
                } else {
                    onComplete()
                }
            } catch {
                errorMessage = "Gjenoppretting mislyktes."
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
        case .weekly:  return "Ukentlig"
        case .monthly: return "Manedlig"
        case .annual:  return "Arlig"
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
                            Text("Beste verdi")
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
                in: RoundedRectangle(cornerRadius: 14)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isSelected ? Color.clear : (isBestValue ? SkinTheme.accent.opacity(0.4) : SkinTheme.accent.opacity(0.15)),
                        lineWidth: isBestValue && !isSelected ? 1.5 : 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
