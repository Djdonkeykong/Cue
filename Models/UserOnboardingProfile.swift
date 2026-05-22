import Foundation

enum Gender: String, Codable, CaseIterable {
    case male, female, nonBinary, preferNotToSay

    var displayName: String {
        switch self {
        case .male:           return "Mann"
        case .female:         return "Kvinne"
        case .nonBinary:      return "Ikke-binar"
        case .preferNotToSay: return "Vil ikke si"
        }
    }
}

enum ConcernDuration: String, Codable, CaseIterable {
    case lessThan3Months, threeToSixMonths, sixMonthsToOneYear, oneToThreeYears, moreThanThreeYears

    var displayName: String {
        switch self {
        case .lessThan3Months:    return "Under 3 maneder"
        case .threeToSixMonths:   return "3-6 maneder"
        case .sixMonthsToOneYear: return "6 maneder - 1 ar"
        case .oneToThreeYears:    return "1-3 ar"
        case .moreThanThreeYears: return "Mer enn 3 ar"
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
        case .none:      return "Ingen rutine"
        case .basic:     return "Grunnleggende"
        case .moderate:  return "Moderat"
        case .extensive: return "Omfattende"
        }
    }

    var description: String {
        switch self {
        case .none:      return "Vasker ansiktet av og til"
        case .basic:     return "Rens og fuktighetskrem"
        case .moderate:  return "Rens, toner, serum, fuktighetskrem"
        case .extensive: return "Full rutine med mange steg"
        }
    }
}

enum RoutineConsistency: String, Codable, CaseIterable {
    case never, sometimes, often, daily

    var displayName: String {
        switch self {
        case .never:     return "Sjelden"
        case .sometimes: return "Av og til"
        case .often:     return "Ofte"
        case .daily:     return "Daglig"
        }
    }

    var description: String {
        switch self {
        case .never:     return "1-2 ganger i uken eller sjeldnere"
        case .sometimes: return "3-4 ganger i uken"
        case .often:     return "Nesten hver dag"
        case .daily:     return "To ganger daglig uten unntak"
        }
    }
}

enum LifestyleFactor: String, Codable, CaseIterable {
    case poorSleep, highStress, poorDiet, smoking, heavyExercise, sunExposure, dairy, sugar

    var displayName: String {
        switch self {
        case .poorSleep:     return "Darlig sovn"
        case .highStress:    return "Hoyt stressniva"
        case .poorDiet:      return "Usunt kosthold"
        case .smoking:       return "Royking"
        case .heavyExercise: return "Intensiv trening"
        case .sunExposure:   return "Mye sol"
        case .dairy:         return "Mye meieri"
        case .sugar:         return "Mye sukker"
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
        case .notSensitive: return "Ikke sensitiv"
        case .somewhat:     return "Litt sensitiv"
        case .very:         return "Veldig sensitiv"
        case .extremely:    return "Ekstremt sensitiv"
        }
    }

    var description: String {
        switch self {
        case .notSensitive: return "Reagerer sjelden pa produkter"
        case .somewhat:     return "Noen produkter irriterer huden"
        case .very:         return "Mange produkter irriterer huden"
        case .extremely:    return "Nesten alt gir reaksjon"
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
