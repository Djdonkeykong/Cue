import Foundation

enum Gender: String, Codable, CaseIterable {
    case male, female, preferNotToSay

    var displayName: String {
        switch self {
        case .male:           return "Male"
        case .female:         return "Female"
        case .preferNotToSay: return "Prefer not to say"
        }
    }

    var systemImage: String {
        switch self {
        case .male:           return "person.fill"
        case .female:         return "person.crop.square.fill"
        case .preferNotToSay: return "questionmark.circle.fill"
        }
    }
}

enum PrimaryConcern: String, Codable, CaseIterable {
    case pimplesAndBreakouts = "pimples_and_breakouts"
    case blackheadsAndPores  = "blackheads_and_pores"
    case darkSpotsAndTone    = "dark_spots_and_tone"
    case oilyAndShiny        = "oily_and_shiny"

    var displayName: String {
        switch self {
        case .pimplesAndBreakouts: return "Pimples & breakouts"
        case .blackheadsAndPores:  return "Blackheads & clogged pores"
        case .darkSpotsAndTone:    return "Dark spots & uneven tone"
        case .oilyAndShiny:        return "Oily & shiny skin"
        }
    }

    var description: String {
        switch self {
        case .pimplesAndBreakouts: return "Frequent or occasional acne flare-ups"
        case .blackheadsAndPores:  return "Congested pores and visible blackheads"
        case .darkSpotsAndTone:    return "Post-acne marks or uneven complexion"
        case .oilyAndShiny:        return "Excess sebum throughout the day"
        }
    }

    var systemImage: String {
        switch self {
        case .pimplesAndBreakouts: return "circle.dotted"
        case .blackheadsAndPores:  return "circle.fill"
        case .darkSpotsAndTone:    return "square.on.square.dashed"
        case .oilyAndShiny:        return "drop.fill"
        }
    }
}

enum SkinTrend: String, Codable, CaseIterable {
    case gettingBetter = "getting_better"
    case aboutTheSame  = "about_the_same"
    case gettingWorse  = "getting_worse"

    var displayName: String {
        switch self {
        case .gettingBetter: return "Getting better"
        case .aboutTheSame:  return "About the same"
        case .gettingWorse:  return "Getting worse"
        }
    }

    var systemImage: String {
        switch self {
        case .gettingBetter: return "arrow.up.right.circle.fill"
        case .aboutTheSame:  return "arrow.right.circle.fill"
        case .gettingWorse:  return "arrow.down.right.circle.fill"
        }
    }
}

enum LifestyleTrigger: String, Codable, CaseIterable {
    case dietAndFood    = "diet_and_food"
    case stressAndSleep = "stress_and_sleep"
    case hormoneChanges = "hormone_changes"
    case notSure        = "not_sure"

    var displayName: String {
        switch self {
        case .dietAndFood:    return "What I eat and drink"
        case .stressAndSleep: return "Stress and lack of sleep"
        case .hormoneChanges: return "Hormone changes"
        case .notSure:        return "I'm not sure"
        }
    }

    var description: String {
        switch self {
        case .dietAndFood:    return "Dairy, sugar, processed foods"
        case .stressAndSleep: return "Work, life, and poor rest"
        case .hormoneChanges: return "Cycle, age, or medication related"
        case .notSure:        return "Help me figure it out"
        }
    }

    var systemImage: String {
        switch self {
        case .dietAndFood:    return "fork.knife"
        case .stressAndSleep: return "brain.head.profile"
        case .hormoneChanges: return "waveform"
        case .notSure:        return "questionmark.circle.fill"
        }
    }
}

enum ConcernDuration: String, Codable, CaseIterable {
    case lessThan6Months  = "less_than_6_months"
    case sixTo12Months    = "six_to_12_months"
    case oneToTwoYears    = "one_to_two_years"
    case moreThanTwoYears = "more_than_two_years"

    var displayName: String {
        switch self {
        case .lessThan6Months:  return "Less than 6 months"
        case .sixTo12Months:    return "6 to 12 months"
        case .oneToTwoYears:    return "1 to 2 years"
        case .moreThanTwoYears: return "More than 2 years"
        }
    }

    var systemImage: String {
        switch self {
        case .lessThan6Months:  return "clock"
        case .sixTo12Months:    return "calendar"
        case .oneToTwoYears:    return "calendar.badge.clock"
        case .moreThanTwoYears: return "hourglass"
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
        case .none:      return "I just wash my face occasionally"
        case .basic:     return "Cleanser and moisturizer"
        case .moderate:  return "Cleanser, toner, serum, moisturizer"
        case .extensive: return "Full multi-step routine"
        }
    }

    var systemImage: String {
        switch self {
        case .none:      return "xmark.circle.fill"
        case .basic:     return "drop.fill"
        case .moderate:  return "sparkles"
        case .extensive: return "star.fill"
        }
    }
}

enum RoutineConsistency: String, Codable, CaseIterable {
    case rarely, sometimes, often, daily

    var displayName: String {
        switch self {
        case .rarely:    return "Rarely"
        case .sometimes: return "Sometimes"
        case .often:     return "Often"
        case .daily:     return "Every day"
        }
    }

    var description: String {
        switch self {
        case .rarely:    return "1 to 2 times a week or less"
        case .sometimes: return "3 to 4 times a week"
        case .often:     return "Almost every day"
        case .daily:     return "Twice daily without exception"
        }
    }

    var systemImage: String {
        switch self {
        case .rarely:    return "tortoise.fill"
        case .sometimes: return "clock.fill"
        case .often:     return "arrow.clockwise.circle.fill"
        case .daily:     return "checkmark.seal.fill"
        }
    }
}

enum SensitivityLevel: String, Codable, CaseIterable {
    case notSensitive = "not_sensitive"
    case somewhat     = "somewhat"
    case very         = "very"
    case extremely    = "extremely"

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

    var systemImage: String {
        switch self {
        case .notSensitive: return "shield.fill"
        case .somewhat:     return "shield.lefthalf.filled"
        case .very:         return "exclamationmark.triangle.fill"
        case .extremely:    return "flame.fill"
        }
    }
}

struct UserOnboardingProfile: Codable, Identifiable {
    var id: UUID = .init()
    let userId: String
    var displayName: String?
    var gender: Gender
    var primaryConcern: PrimaryConcern
    var skinType: SkinType
    var sensitivityLevel: SensitivityLevel
    var concernSeverity: Int
    var concernDuration: ConcernDuration
    var skinTrend: SkinTrend
    var skincareRoutine: SkincareRoutine
    var consistency: RoutineConsistency
    var lifestyleTrigger: LifestyleTrigger
    var age: Int?
    var primaryGoal: String?
    var onboardingCompletedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case userId                = "user_id"
        case displayName           = "display_name"
        case gender
        case primaryConcern        = "primary_concern"
        case skinType              = "skin_type"
        case sensitivityLevel      = "sensitivity_level"
        case concernSeverity       = "concern_severity"
        case concernDuration       = "concern_duration"
        case skinTrend             = "skin_trend"
        case skincareRoutine       = "skincare_routine"
        case consistency
        case lifestyleTrigger      = "lifestyle_trigger"
        case age
        case primaryGoal           = "primary_goal"
        case onboardingCompletedAt = "onboarding_completed_at"
    }
}
