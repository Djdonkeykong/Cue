import SwiftUI

struct OnboardingQuizRootView: View {
    @AppStorage("cue.onboardingCompleted") private var onboardingCompleted = false
    @EnvironmentObject private var authManager: AuthManager
    @State private var vm = OnboardingViewModel()
    @State private var step = 0

    private let totalQuizSteps = 9

    var body: some View {
        ZStack(alignment: .top) {
            SkinTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                if step < totalQuizSteps {
                    ProgressView(value: Double(step + 1), total: Double(totalQuizSteps))
                        .tint(SkinTheme.accent)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .animation(.easeInOut(duration: 0.3), value: step)
                }

                quizContent
                    .id(step)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal:   .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
        .animation(.spring(duration: 0.35), value: step)
    }

    @ViewBuilder
    private var quizContent: some View {
        switch step {
        case 0:  QuizGenderView(vm: vm)                         { step += 1 }
        case 1:  QuizSkinTypeView(vm: vm)                       { step += 1 }
        case 2:  QuizConcernsView(vm: vm)                       { step += 1 }
        case 3:  QuizSeverityView(vm: vm)                       { step += 1 }
        case 4:  QuizDurationView(vm: vm)                       { step += 1 }
        case 5:  QuizAgeView(vm: vm)                            { step += 1 }
        case 6:  QuizRoutineView(vm: vm)                        { step += 1 }
        case 7:  QuizLifestyleView(vm: vm)                      { step += 1 }
        case 8:  QuizGoalView(vm: vm)                           { step += 1 }
        case 9:  OnboardingAnalyzingView                        { step += 1 }
        case 10: OnboardingResultsPreviewView(vm: vm)           { step += 1 }
        case 11: OnboardingSocialProofView                      { step += 1 }
        default: OnboardingPaywallView(vm: vm, onComplete: finish)
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
