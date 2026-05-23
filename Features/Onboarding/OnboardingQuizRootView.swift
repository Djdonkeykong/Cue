import SwiftUI

struct OnboardingQuizRootView: View {
    @Bindable var vm: OnboardingViewModel
    let onComplete: () -> Void

    @State private var step = 0
    private let totalQuizSteps = 11

    var body: some View {
        ZStack {
            SkinTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    if step > 0 {
                        BackButton { goBack() }
                    } else {
                        Color.clear.frame(width: 38, height: 38)
                    }

                    ProgressView(value: Double(step + 1), total: Double(totalQuizSteps))
                        .tint(SkinTheme.accent)
                        .animation(.easeInOut(duration: 0.3), value: step)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                quizContent
                    .id(step)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.07), value: step)
            }
        }
    }

    @ViewBuilder
    private var quizContent: some View {
        switch step {
        case 0:  QuizGenderView(vm: vm)          { advance() }
        case 1:  QuizPrimaryConcernView(vm: vm)  { advance() }
        case 2:  QuizSkinTypeView(vm: vm)        { advance() }
        case 3:  QuizSensitivityView(vm: vm)     { advance() }
        case 4:  QuizSeveritySliderView(vm: vm)  { advance() }
        case 5:  QuizDurationView(vm: vm)        { advance() }
        case 6:  QuizSkinTrendView(vm: vm)       { advance() }
        case 7:  QuizRoutineView(vm: vm)         { advance() }
        case 8:  QuizConsistencyView(vm: vm)     { advance() }
        case 9:  QuizTriggerView(vm: vm)         { advance() }
        default: QuizGoalView(vm: vm)            { advance() }
        }
    }

    private func advance() {
        if step >= totalQuizSteps - 1 {
            onComplete()
            return
        }
        withAnimation(.easeInOut(duration: 0.07)) { step += 1 }
    }

    private func goBack() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation(.easeInOut(duration: 0.07)) { step -= 1 }
    }
}
