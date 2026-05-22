import SwiftUI

// MARK: - Shared layout wrapper

struct QuizScreen<Content: View>: View {
    let title: String
    let subtitle: String?
    let continueEnabled: Bool
    let onContinue: () -> Void
    @ViewBuilder let content: () -> Content

    init(
        title: String,
        subtitle: String? = nil,
        continueEnabled: Bool = true,
        onContinue: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.continueEnabled = continueEnabled
        self.onContinue = onContinue
        self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(.skin(.title2, weight: .bold))
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

            Button("Continue", action: onContinue)
                .font(.skin(.body, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    continueEnabled ? SkinTheme.accent : SkinTheme.accent.opacity(0.35),
                    in: Capsule()
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 36)
                .disabled(!continueEnabled)
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
        Button(action: action) {
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
                in: RoundedRectangle(cornerRadius: 14)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isSelected ? Color.clear : SkinTheme.accent.opacity(0.15),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quiz: Gender

struct QuizGenderView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(title: "Who are you?", onContinue: onContinue) {
            VStack(spacing: 10) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    QuizOptionCard(title: gender.displayName, isSelected: vm.gender == gender) {
                        vm.gender = gender
                    }
                }
            }
        }
    }
}

// MARK: - Quiz: Skin type

struct QuizSkinTypeView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(
            title: "What's your skin type?",
            subtitle: "Choose the option that fits best.",
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
                    }
                }
            }
        }
    }
}

// MARK: - Quiz: Concerns (multi-select)

struct QuizConcernsView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(
            title: "What skin concerns do you have?",
            subtitle: "Select all that apply.",
            continueEnabled: !vm.concerns.isEmpty,
            onContinue: onContinue
        ) {
            VStack(spacing: 10) {
                ForEach(SkinConcern.allCases, id: \.self) { concern in
                    let selected = vm.concerns.contains(concern)
                    QuizOptionCard(
                        title: concern.displayName,
                        icon: concern.systemImage,
                        isSelected: selected
                    ) {
                        if selected { vm.concerns.remove(concern) }
                        else        { vm.concerns.insert(concern) }
                    }
                }
            }
        }
    }
}

// MARK: - Quiz: Severity

struct QuizSeverityView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    private let options: [(label: String, detail: String, value: Int)] = [
        ("Mild",     "Rarely a breakout",                          1),
        ("Light",    "A few occasional blemishes",                 2),
        ("Moderate", "Noticeable breakouts regularly",             3),
        ("Severe",   "Frequent and painful breakouts",             4),
        ("Very severe", "Persistent, covering large areas",        5),
    ]

    var body: some View {
        QuizScreen(title: "How severe is the problem?", onContinue: onContinue) {
            VStack(spacing: 10) {
                ForEach(options, id: \.value) { opt in
                    QuizOptionCard(
                        title: opt.label,
                        subtitle: opt.detail,
                        isSelected: vm.severity == opt.value
                    ) {
                        vm.severity = opt.value
                    }
                }
            }
        }
    }
}

// MARK: - Quiz: Duration

struct QuizDurationView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(
            title: "How long have you had these concerns?",
            onContinue: onContinue
        ) {
            VStack(spacing: 10) {
                ForEach(ConcernDuration.allCases, id: \.self) { dur in
                    QuizOptionCard(title: dur.displayName, isSelected: vm.duration == dur) {
                        vm.duration = dur
                    }
                }
            }
        }
    }
}

// MARK: - Quiz: Age

struct QuizAgeView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(title: "What's your age group?", onContinue: onContinue) {
            VStack(spacing: 10) {
                ForEach(AgeRange.allCases, id: \.self) { age in
                    QuizOptionCard(title: age.displayName, isSelected: vm.ageRange == age) {
                        vm.ageRange = age
                    }
                }
            }
        }
    }
}

// MARK: - Quiz: Routine + consistency

struct QuizRoutineView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(title: "What's your skincare routine like?", onContinue: onContinue) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 10) {
                    ForEach(SkincareRoutine.allCases, id: \.self) { routine in
                        QuizOptionCard(
                            title: routine.displayName,
                            subtitle: routine.description,
                            isSelected: vm.routine == routine
                        ) {
                            vm.routine = routine
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("How consistent are you?")
                        .font(.skin(.headline, weight: .semibold))
                        .foregroundStyle(SkinTheme.primaryText)

                    VStack(spacing: 10) {
                        ForEach(RoutineConsistency.allCases, id: \.self) { c in
                            QuizOptionCard(
                                title: c.displayName,
                                subtitle: c.description,
                                isSelected: vm.consistency == c
                            ) {
                                vm.consistency = c
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Quiz: Lifestyle (multi-select)

struct QuizLifestyleView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    var body: some View {
        QuizScreen(
            title: "What sounds like you?",
            subtitle: "Select all that apply. We use this to find your triggers.",
            onContinue: onContinue
        ) {
            VStack(spacing: 10) {
                ForEach(LifestyleFactor.allCases, id: \.self) { factor in
                    let selected = vm.lifestyleFactors.contains(factor)
                    QuizOptionCard(
                        title: factor.displayName,
                        icon: factor.icon,
                        isSelected: selected
                    ) {
                        if selected { vm.lifestyleFactors.remove(factor) }
                        else        { vm.lifestyleFactors.insert(factor) }
                    }
                }
            }
        }
    }
}

// MARK: - Quiz: Goal + name

struct QuizGoalView: View {
    @Bindable var vm: OnboardingViewModel
    let onContinue: () -> Void

    private let goals = [
        "Get clearer skin",
        "Understand what triggers my acne",
        "Find safe products",
        "Reduce blackheads and large pores",
        "Build an effective skincare routine",
    ]

    var body: some View {
        QuizScreen(title: "What's your goal?", subtitle: "Choose what matters most to you right now.", onContinue: onContinue) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 10) {
                    ForEach(goals, id: \.self) { goal in
                        QuizOptionCard(title: goal, isSelected: vm.primaryGoal == goal) {
                            vm.primaryGoal = goal
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("What's your name? (optional)")
                        .font(.skin(.callout, weight: .semibold))
                        .foregroundStyle(SkinTheme.primaryText)
                    TextField("Your first name", text: $vm.displayName)
                        .font(.skin(.body))
                        .padding(14)
                        .background(SkinTheme.inputSurface, in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}
