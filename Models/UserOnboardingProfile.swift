import Foundation

enum Gender: String, Codable, CaseIterable {
    case male, female, nonBinary, preferNotToSay

    var displayName: String {
        switch self {
        case .male:           return "Male"
        case .female:         return "Female"
        case .nonBinary:      return "Non-binary"
        case .preferNotToSay: return "Prefer not to say"
        }
    }
}

enum ConcernDuration: String, Codable, CaseIterable {
    case lessThan3Months, threeToSixMonths, sixMonthsToOneYear, oneToThreeYears, moreThanThreeYears

    var displayName: String {
        switch self {
        case .lessThan3Months:    return "Less than 3 months"
        case .threeToSixMonths:   return "3-6 months"
        case .sixMonthsToOneYear: return "6 months - 1 year"
        case .oneToThreeYears:    return "1-3 years"
        case .moreThanThreeYears: return "More than 3 years"
        }
    }
}

enum AgeRange: String, Codable, CaseIterable {
    case under18, eighteenTo24, twentyFiveTo34, thirtyFiveTo44, fortyFivePlus

    var displayName: String {
        switch self {
        case .under18:        return "Under 18"
        case .eighteenTo24:   return "18-24"
        case .twentyFiveTo34: return "25-34"
        case .thirtyFiveTo44: return "35-44"
        case .fortyFivePlus:  return "45+"
        }
    }
}

enum SkincareRoutine: String, Codable, CaseIterable {
    case none, basic, moderate, extensive

    var displayName: String {
        switch self {
        case .none:      return "No routine"
        case .basic:     return "Basic"
        case .moderate:  return "Moderate"
        case .extensive: return "Extensive"
        }
    }

    var description: String {
        switch self {
        case .none:      return "Wash my face occasionally"
        case .basic:     return "Cleanser and moisturizer"
        case .moderate:  return "Cleanser, toner, serum, moisturizer"
        case .extensive: return "Full multi-step routine"
        }
    }
}

enum RoutineConsistency: String, Codable, CaseIterable {
    case never, sometimes, often, daily

    var displayName: String {
        switch self {
        case .never:     return "Rarely"
        case .sometimes: return "Sometimes"
        case .often:     return "Often"
        case .daily:     return "Daily"
        }
    }

    var description: String {
        switch self {
        case .never:     return "1-2 times a week or less"
        case .sometimes: return "3-4 times a week"
        case .often:     return "Almost every day"
        case .daily:     return "Twice daily without exception"
        }
    }
}

enum LifestyleFactor: String, Codable, CaseIterable {
    case poorSleep, highStress, poorDiet, smoking, heavyExercise, sunExposure, dairy, sugar

    var displayName: String {
        switch self {
        case .poorSleep:     return "Poor sleep"
        case .highStress:    return "High stress levels"
        case .poorDiet:      return "Unhealthy diet"
        case .smoking:       return "Smoking"
        case .heavyExercise: return "Intense exercise"
        case .sunExposure:   return "Lots of sun exposure"
        case .dairy:         return "High dairy intake"
        case .sugar:         return "High sugar intake"
        }
    }

    var icon: String {
        switch self {
        case .poorSleep:     return "moon.zzz.fill"
        case .highStress:    return "brain.head.profile"
        case .poorDiet:      return "fork.knife"
        case .smoking:       return "smoke.fill"
        case .heavyExercise: return "figure.run"
        case .sunExposure:   return "sun.max.fill"
        case .dairy:         return "cup.and.saucer.fill"
        case .sugar:         return "birthday.cake.fill"
        }
    }
}

enum SensitivityLevel: String, Codable, CaseIterable {
    case notSensitive, somewhat, very, extremely

    var displayName: String {
        switch self {
        case .notSensitive: return "Not sensitive"
        case .somewhat:     return "Slightly sensitive"
        case .very:         return "Very sensitive"
        case .extremely:    return "Extremely sensitive"
        }
    }

    var description: String {
        switch self {
        case .notSensitive: return "Rarely reacts to products"
        case .somewhat:     return "Some products irritate my skin"
        case .very:         return "Many products irritate my skin"
        case .extremely:    return "Almost everything causes a reaction"
        }
    }
}

struct UserOnboardingProfile: Codable, Identifiable {
    var id: UUID = .init()
    let userId: String
    var displayName: String?
    var gender: Gender
    var skinType: SkinType
    var skinConcerns: [SkinConcern]
    var concernSeverity: Int
    var concernDuration: ConcernDuration
    var ageRange: AgeRange
    var skincareRoutine: SkincareRoutine
    var consistency: RoutineConsistency
    var lifestyleFactors: [LifestyleFactor]
    var sensitivityLevel: SensitivityLevel
    var primaryGoal: String?
    var onboardingCompletedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case userId                = "user_id"
        case displayName           = "display_name"
        case gender
        case skinType              = "skin_type"
        case skinConcerns          = "skin_concerns"
        case concernSeverity       = "concern_severity"
        case concernDuration       = "concern_duration"
        case ageRange              = "age_range"
        case skincareRoutine       = "skincare_routine"
        case consistency
        case lifestyleFactors      = "lifestyle_factors"
        case sensitivityLevel      = "sensitivity_level"
        case primaryGoal           = "primary_goal"
        case onboardingCompletedAt = "onboarding_completed_at"
    }
}
