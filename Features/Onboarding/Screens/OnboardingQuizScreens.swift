import SwiftUI

// MARK: - Shared layout wrapper

struct QuizScreen<Content: View>: View {
    let title: String
    let subtitle: String?
    let continueEnabled: Bool
    let showContinueButton: Bool
    let onContinue: () -> Void
    @ViewBuilder let content: () -> Content

    init(
        title: String,
        subtitle: String? = nil,
        continueEnabled: Bool = true,
        showContinueButton: Bool = true,
        onContinue: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.continueEnabled = continueEnabled
        self.showContinueButton = showContinueButton
        self.onContinue = onContinue
        self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(.cue(.heading2))
                            .foregroundStyle(SkinTheme.primaryText)
                        if let subtitle {
                            Text(subtitle)
                                .font(.skin(.callout))
                                .foregroundStyle(SkinTheme.secondaryText)
                        }
                    }
                    content()
                }
                .padding(24)
                .padding(.bottom, 8)
            }

            if showContinueButton {
                PrimaryButton("Continue", isEnabled: continueEnabled, action: onContinue)
                    .padding(.bottom, 36)
            }
        }
    }
}

// MARK: - Option card

struct QuizOptionCard: View {
    let title: String
    let subtitle: String?
    let icon: String?
    let isSelected: Bool
    let action: () -> Void

    init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        } label: {
            HStack(spacing: 12) {
                if let icon {
                    Image(systemName: icon)
                        .font(.body)
                        .foregroundStyle(isSelected ? .white : SkinTheme.accent)
                        .frame(width: 26)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.skin(.callout, weight: .semibold))
                        .foregroundStyle(isSelected ? .white : SkinTheme.primaryText)
                    if let subtitle {
                        Text(subtitle)
                            .font(.skin(.footnote))
                            .foregroundStyle(isSelected ? .white.opacity(0.75) : SkinTheme.secondaryText)
                    }
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
                        isSelected ? Color.clear : SkinTheme.accent.opacity(0.15),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Q0: Gender

struct QuizGenderView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(title: "Who are you?", showContinueButton: false, onContinue: onContinue) {
            VStack(spacing: 10) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    QuizOptionCard(title: gender.displayName, icon: gender.systemImage, isSelected: vm.gender == gender) {
                        vm.gender = gender
                        advance()
                    }
                }
            }
        }
    }

    private func advance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { onContinue() }
    }
}

// MARK: - Q1: Primary concern

struct QuizPrimaryConcernView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(
            title: "What's your main skin concern?",
            subtitle: "Choose the one that fits best.",
            showContinueButton: false,
            onContinue: onContinue
        ) {
            VStack(spacing: 10) {
                ForEach(PrimaryConcern.allCases, id: \.self) { concern in
                    QuizOptionCard(
                        title: concern.displayName,
                        subtitle: concern.description,
                        icon: concern.systemImage,
                        isSelected: vm.primaryConcern == concern
                    ) {
                        vm.primaryConcern = concern
                        advance()
                    }
                }
            }
        }
    }

    private func advance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { onContinue() }
    }
}

// MARK: - Q2: Skin type

struct QuizSkinTypeView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(
            title: "What's your skin type?",
            subtitle: "Choose the option that fits best.",
            showContinueButton: false,
            onContinue: onContinue
        ) {
            VStack(spacing: 10) {
                ForEach(SkinType.allCases, id: \.self) { type in
                    QuizOptionCard(
                        title: type.displayName,
                        subtitle: type.description,
                        icon: type.systemImage,
                        isSelected: vm.skinType == type
                    ) {
                        vm.skinType = type
                        advance()
                    }
                }
            }
        }
    }

    private func advance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { onContinue() }
    }
}

// MARK: - Q3: Sensitivity

struct QuizSensitivityView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(title: "How sensitive is your skin?", showContinueButton: false, onContinue: onContinue) {
            VStack(spacing: 10) {
                ForEach(SensitivityLevel.allCases, id: \.self) { level in
                    QuizOptionCard(
                        title: level.displayName,
                        subtitle: level.description,
                        icon: level.systemImage,
                        isSelected: vm.sensitivityLevel == level
                    ) {
                        vm.sensitivityLevel = level
                        advance()
                    }
                }
            }
        }
    }

    private func advance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { onContinue() }
    }
}

// MARK: - Q4: Severity (slider)

struct QuizSeveritySliderView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void
    private let levels: [(label: String, detail: String)] = [
        ("Mild",        "Rarely a breakout"),
        ("Light",       "Occasional blemishes"),
        ("Moderate",    "Regular noticeable breakouts"),
        ("Severe",      "Frequent and painful breakouts"),
        ("Very severe", "Persistent, covering large areas"),
    ]

    private var current: (label: String, detail: String) { levels[vm.severity - 1] }

    var body: some View {
        QuizScreen(title: "How severe is the problem?", subtitle: "Drag to describe your typical skin day.", onContinue: onContinue) {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(current.label)
                        .font(.cue(.heading3))
                        .foregroundStyle(SkinTheme.primaryText)
                    Text(current.detail)
                        .font(.skin(.callout))
                        .foregroundStyle(SkinTheme.secondaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(SkinTheme.surface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(SkinTheme.accent.opacity(0.25), lineWidth: 1)
                )
                .animation(.easeInOut(duration: 0.15), value: vm.severity)

                VStack(spacing: 10) {
                    Slider(
                        value: Binding(
                            get: { Double(vm.severity) },
                            set: { vm.severity = Int($0.rounded()) }
                        ),
                        in: 1...5,
                        step: 1
                    )
                    .tint(SkinTheme.accent)

                    HStack {
                        Text("Mild")
                            .font(.skin(.caption))
                            .foregroundStyle(SkinTheme.secondaryText)
                        Spacer()
                        Text("Very severe")
                            .font(.skin(.caption))
                            .foregroundStyle(SkinTheme.secondaryText)
                    }
                }
            }
        }
    }
}

// MARK: - Q5: Duration

struct QuizDurationView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(title: "How long have you had this concern?", showContinueButton: false, onContinue: onContinue) {
            VStack(spacing: 10) {
                ForEach(ConcernDuration.allCases, id: \.self) { dur in
                    QuizOptionCard(title: dur.displayName, icon: dur.systemImage, isSelected: vm.duration == dur) {
                        vm.duration = dur
                        advance()
                    }
                }
            }
        }
    }

    private func advance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { onContinue() }
    }
}

// MARK: - Q6: Skin trend

struct QuizSkinTrendView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(title: "How has your skin been lately?", showContinueButton: false, onContinue: onContinue) {
            VStack(spacing: 10) {
                ForEach(SkinTrend.allCases, id: \.self) { trend in
                    QuizOptionCard(title: trend.displayName, icon: trend.systemImage, isSelected: vm.skinTrend == trend) {
                        vm.skinTrend = trend
                        advance()
                    }
                }
            }
        }
    }

    private func advance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { onContinue() }
    }
}

// MARK: - Q7: Skincare routine

struct QuizRoutineView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(title: "What's your skincare routine like?", showContinueButton: false, onContinue: onContinue) {
            VStack(spacing: 10) {
                ForEach(SkincareRoutine.allCases, id: \.self) { routine in
                    QuizOptionCard(
                        title: routine.displayName,
                        subtitle: routine.description,
                        icon: routine.systemImage,
                        isSelected: vm.routine == routine
                    ) {
                        vm.routine = routine
                        advance()
                    }
                }
            }
        }
    }

    private func advance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { onContinue() }
    }
}

// MARK: - Q8: Routine consistency

struct QuizConsistencyView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(title: "How consistent are you?", showContinueButton: false, onContinue: onContinue) {
            VStack(spacing: 10) {
                ForEach(RoutineConsistency.allCases, id: \.self) { c in
                    QuizOptionCard(
                        title: c.displayName,
                        subtitle: c.description,
                        icon: c.systemImage,
                        isSelected: vm.consistency == c
                    ) {
                        vm.consistency = c
                        advance()
                    }
                }
            }
        }
    }

    private func advance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { onContinue() }
    }
}

// MARK: - Q9: Lifestyle trigger

struct QuizTriggerView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(
            title: "What's your main trigger?",
            subtitle: "Your best guess is fine.",
            showContinueButton: false,
            onContinue: onContinue
        ) {
            VStack(spacing: 10) {
                ForEach(LifestyleTrigger.allCases, id: \.self) { trigger in
                    QuizOptionCard(
                        title: trigger.displayName,
                        subtitle: trigger.description,
                        icon: trigger.systemImage,
                        isSelected: vm.lifestyleTrigger == trigger
                    ) {
                        vm.lifestyleTrigger = trigger
                        advance()
                    }
                }
            }
        }
    }

    private func advance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { onContinue() }
    }
}

// MARK: - Q10: Goal

struct QuizGoalView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    private let goals: [(text: String, icon: String)] = [
        ("Get clearer skin",                    "sparkle"),
        ("Understand what triggers my acne",    "magnifyingglass"),
        ("Find safe products",                  "checkmark.seal.fill"),
        ("Reduce blackheads and large pores",   "circle.dashed"),
        ("Build an effective skincare routine",  "list.clipboard.fill"),
    ]

    var body: some View {
        QuizScreen(
            title: "What's your goal?",
            subtitle: "Choose what matters most to you right now.",
            continueEnabled: !vm.primaryGoal.isEmpty,
            onContinue: onContinue
        ) {
            VStack(spacing: 10) {
                ForEach(goals, id: \.text) { goal in
                    QuizOptionCard(title: goal.text, icon: goal.icon, isSelected: vm.primaryGoal == goal.text) {
                        vm.primaryGoal = goal.text
                    }
                }
            }
        }
    }
}

// MARK: - Age input (outside quiz)

struct QuizAgeInputView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void
    @State private var selectedAge: Int = 18

    var body: some View {
        ZStack {
            SkinTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Text("How old are you?")
                    .font(.cue(.heading1))
                    .foregroundStyle(SkinTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Picker("Age", selection: $selectedAge) {
                    ForEach(13...80, id: \.self) { age in
                        Text("\(age)").tag(age)
                    }
                }
                .pickerStyle(.wheel)
                .tint(SkinTheme.accent)

                Spacer()

                PrimaryButton("Continue") {
                    vm.age = String(selectedAge)
                    onContinue()
                }
                .padding(.bottom, 36)
            }
        }
        .onAppear {
            if let existing = Int(vm.age) { selectedAge = existing }
        }
    }
}

// MARK: - Name input (outside quiz)

struct QuizNameView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void
    @FocusState private var focused: Bool

    var body: some View {
        ZStack {
            SkinTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 16) {
                    Text("What should we call you?")
                        .font(.cue(.heading1))
                        .foregroundStyle(SkinTheme.primaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    TextField("Your name", text: $vm.displayName)
                        .focused($focused)
                        .multilineTextAlignment(.center)
                        .font(.cue(.heading1))
                        .foregroundStyle(SkinTheme.primaryText)
                        .frame(maxWidth: .infinity)
                }

                Spacer()

                PrimaryButton("Continue", isEnabled: !vm.displayName.isEmpty, action: onContinue)
                    .padding(.bottom, 36)
            }
        }
        .onAppear { focused = true }
    }
}
