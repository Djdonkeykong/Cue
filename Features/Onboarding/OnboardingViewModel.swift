import SwiftUI

@Observable
final class OnboardingViewModel {
    var displayName      = ""
    var gender           : Gender?            = nil
    var primaryConcern   : PrimaryConcern?    = nil
    var skinType         : SkinType?          = nil
    var sensitivityLevel : SensitivityLevel?  = nil
    var severity         = 1
    var duration         : ConcernDuration?   = nil
    var skinTrend        : SkinTrend?         = nil
    var routine          : SkincareRoutine?   = nil
    var consistency      : RoutineConsistency? = nil
    var lifestyleTrigger : LifestyleTrigger?  = nil
    var age              = ""
    var primaryGoal      = ""

    func buildOnboardingProfile(userId: String) -> UserOnboardingProfile {
        UserOnboardingProfile(
            userId: userId,
            displayName: displayName.isEmpty ? nil : displayName,
            gender: gender ?? .preferNotToSay,
            primaryConcern: primaryConcern ?? .pimplesAndBreakouts,
            skinType: skinType ?? .combination,
            sensitivityLevel: sensitivityLevel ?? .somewhat,
            concernSeverity: severity,
            concernDuration: duration ?? .lessThan6Months,
            skinTrend: skinTrend ?? .aboutTheSame,
            skincareRoutine: routine ?? .basic,
            consistency: consistency ?? .sometimes,
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
        return SkinProfile(userId: userId, skinType: skinType ?? .combination, skinConcerns: concerns)
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
