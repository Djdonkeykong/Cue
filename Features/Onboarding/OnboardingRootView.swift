import SwiftUI

struct OnboardingRootView: View {
    @EnvironmentObject private var authManager: AuthManager
    @AppStorage("cue.onboardingCompleted") private var onboardingCompleted = false
    @State private var vm = OnboardingViewModel()
    @State private var currentStep: Step = .welcome
    @State private var stepHistory: [Step] = []

    private enum Step {
        case welcome, painPoint, quiz, age, name,
             analyzing, reveal, results, socialProof, auth, paywall, signIn
    }

    private enum Slot { case a, b }
    @State private var slotA: Step = .welcome
    @State private var slotB: Step = .welcome
    @State private var slotAOffset: CGFloat = 0
    @State private var slotBOffset: CGFloat = 1
    @State private var slotAZIndex: Double = 1
    @State private var slotBZIndex: Double = 0
    @State private var activeSlot: Slot = .a

    var body: some View {
        ZStack {
            SkinTheme.background.ignoresSafeArea()

            GeometryReader { geo in
                ZStack {
                    stepContent(for: slotA)
                        .offset(x: slotAOffset * geo.size.width)
                        .zIndex(slotAZIndex)

                    stepContent(for: slotB)
                        .offset(x: slotBOffset * geo.size.width)
                        .zIndex(slotBZIndex)
                }
                .clipped()
            }
        }
        .onChange(of: authManager.isAuthenticated) { _, isAuth in
            if isAuth && currentStep == .auth { navigate(to: .paywall) }
        }
    }

    @ViewBuilder
    private func stepContent(for step: Step) -> some View {
        switch step {
        case .welcome:
            WelcomeView(
                onContinue: { navigate(to: .painPoint) },
                onSignIn: { navigate(to: .signIn) }
            )
        case .painPoint:
            OnboardingPainPointView { navigate(to: .quiz) }
        case .quiz:
            OnboardingQuizRootView(vm: vm) { navigate(to: .age) }
        case .age:
            QuizAgeInputView(vm: vm, onContinue: { navigate(to: .name) })
        case .name:
            QuizNameView(vm: vm, onContinue: { navigate(to: .analyzing) })
        case .analyzing:
            OnboardingAnalyzingView { navigate(to: .reveal) }
        case .reveal:
            OnboardingRevealView { navigate(to: .results) }
        case .results:
            OnboardingResultsPreviewView(vm: vm) { navigate(to: .socialProof) }
        case .socialProof:
            OnboardingSocialProofView { navigate(to: .auth) }
        case .auth:
            OnboardingAuthView(onSkip: { navigate(to: .paywall) })
        case .paywall:
            OnboardingPaywallView(vm: vm, onComplete: finish)
        case .signIn:
            OnboardingSignInView(
                onBack: { goBack() },
                onSignUp: { navigate(to: .quiz) }
            )
        }
    }

    private func navigate(to step: Step) {
        stepHistory.append(currentStep)
        currentStep = step

        let outgoing: Slot = activeSlot
        let incoming: Slot = activeSlot == .a ? .b : .a

        var snap = Transaction()
        snap.disablesAnimations = true
        withTransaction(snap) {
            switch incoming {
            case .a:
                slotA = step
                slotAOffset = 1
                slotAZIndex = 1
                slotBZIndex = 0
            case .b:
                slotB = step
                slotBOffset = 1
                slotBZIndex = 1
                slotAZIndex = 0
            }
        }

        activeSlot = incoming

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

    private func goBack() {
        guard let prev = stepHistory.popLast() else { return }
        currentStep = prev

        let outgoing: Slot = activeSlot
        let incoming: Slot = activeSlot == .a ? .b : .a

        var snap = Transaction()
        snap.disablesAnimations = true
        withTransaction(snap) {
            switch incoming {
            case .a:
                slotA = prev
                slotAOffset = -1
                slotAZIndex = 0
                slotBZIndex = 1
            case .b:
                slotB = prev
                slotBOffset = -1
                slotBZIndex = 0
                slotAZIndex = 1
            }
        }

        activeSlot = incoming

        withAnimation(.spring(response: 0.38, dampingFraction: 0.96)) {
            switch outgoing {
            case .a:
                slotAOffset = 1
                slotBOffset = 0
            case .b:
                slotBOffset = 1
                slotAOffset = 0
            }
        }
    }

    private func finish() {
        guard let userId = authManager.userId else { return }
        let profile = vm.buildOnboardingProfile(userId: userId)
        let skinProfile = vm.buildSkinProfile(userId: userId)
        Task {
            try? await CloudSyncManager.shared.uploadOnboardingProfile(profile)
            try? await CloudSyncManager.shared.uploadProfile(skinProfile)
        }
        onboardingCompleted = true
    }
}
