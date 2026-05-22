import SwiftUI

@Observable
final class OnboardingViewModel {
    var displayName = ""
    var gender: Gender = .preferNotToSay
    var ageRange: AgeRange = .twentyFiveTo34
    var skinType: SkinType = .combination
    var concerns: Set<SkinConcern> = []
    var severity: Int = 3
    var duration: ConcernDuration = .sixMonthsToOneYear
    var routine: SkincareRoutine = .basic
    var consistency: RoutineConsistency = .sometimes
    var lifestyleFactors: Set<LifestyleFactor> = []
    var sensitivityLevel: SensitivityLevel = .somewhat
    var primaryGoal = ""

    func buildOnboardingProfile(userId: String) -> UserOnboardingProfile {
        UserOnboardingProfile(
            userId: userId,
            displayName: displayName.isEmpty ? nil : displayName,
            gender: gender,
            skinType: skinType,
            skinConcerns: Array(concerns),
            concernSeverity: severity,
            concernDuration: duration,
            ageRange: ageRange,
            skincareRoutine: routine,
            consistency: consistency,
            lifestyleFactors: Array(lifestyleFactors),
            sensitivityLevel: sensitivityLevel,
            primaryGoal: primaryGoal.isEmpty ? nil : primaryGoal,
            onboardingCompletedAt: .now
        )
    }

    func buildSkinProfile(userId: String) -> SkinProfile {
        SkinProfile(userId: userId, skinType: skinType, skinConcerns: Array(concerns))
    }

    var breakoutRiskPercent: Int {
        var base = 38
        if skinType == .oily        { base += 22 }
        if skinType == .combination { base += 10 }
        base += (severity - 1) * 7
        if concerns.contains(.acne)        { base += 8 }
        if concerns.contains(.blackheads)  { base += 4 }
        if lifestyleFactors.contains(.highStress) { base += 5 }
        if lifestyleFactors.contains(.poorSleep)  { base += 4 }
        if lifestyleFactors.contains(.dairy)      { base += 3 }
        return min(base, 97)
    }

    var inflammationLabel: String {
        switch severity {
        case 1, 2: return "Lav"
        case 3:    return "Moderat"
        default:   return "Hoy"
        }
    }
}
