import SwiftUI

@Observable
final class OnboardingViewModel {
    var displayName      = ""
    var gender           = Gender.preferNotToSay
    var primaryConcern   : PrimaryConcern?  = nil
    var skinType         = SkinType.combination
    var sensitivityLevel : SensitivityLevel? = nil
    var severity         = 3
    var duration         = ConcernDuration.lessThan6Months
    var skinTrend        : SkinTrend?        = nil
    var routine          = SkincareRoutine.basic
    var consistency      = RoutineConsistency.sometimes
    var lifestyleTrigger : LifestyleTrigger? = nil
    var age              = ""
    var primaryGoal      = ""

    func buildOnboardingProfile(userId: String) -> UserOnboardingProfile {
        UserOnboardingProfile(
            userId: userId,
            displayName: displayName.isEmpty ? nil : displayName,
            gender: gender,
            primaryConcern: primaryConcern ?? .pimplesAndBreakouts,
            skinType: skinType,
            sensitivityLevel: sensitivityLevel ?? .somewhat,
            concernSeverity: severity,
            concernDuration: duration,
            skinTrend: skinTrend ?? .aboutTheSame,
            skincareRoutine: routine,
            consistency: consistency,
            lifestyleTrigger: lifestyleTrigger ?? .notSure,
            age: Int(age),
            primaryGoal: primaryGoal.isEmpty ? nil : primaryGoal,
            onboardingCompletedAt: .now
        )
    }

    func buildSkinProfile(userId: String) -> SkinProfile {
        let concerns: [SkinConcern] = {
            switch primaryConcern {
            case .pimplesAndBreakouts: return [.acne]
            case .blackheadsAndPores:  return [.blackheads, .largePores]
            case .darkSpotsAndTone:    return [.hyperpigmentation]
            case .oilyAndShiny:        return []
            case nil:                  return []
            }
        }()
        return SkinProfile(userId: userId, skinType: skinType, skinConcerns: concerns)
    }

    var breakoutRiskPercent: Int {
        var base = 38
        if skinType == .oily        { base += 22 }
        if skinType == .combination { base += 10 }
        base += (severity - 1) * 7
        if primaryConcern == .pimplesAndBreakouts { base += 8 }
        if primaryConcern == .blackheadsAndPores  { base += 4 }
        if lifestyleTrigger == .stressAndSleep    { base += 5 }
        if lifestyleTrigger == .dietAndFood       { base += 4 }
        if lifestyleTrigger == .hormoneChanges    { base += 3 }
        return min(base, 97)
    }

    var inflammationLabel: String {
        switch severity {
        case 1, 2: return "Low"
        case 3:    return "Moderate"
        default:   return "High"
        }
    }
}
