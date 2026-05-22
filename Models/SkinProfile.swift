import Foundation

struct SkinProfile: Identifiable, Codable {
    let id: UUID
    var userId: String
    var skinType: SkinType
    var skinConcerns: [SkinConcern]
    var knownAllergens: [String]
    var currentProducts: [String]
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = .init(),
        userId: String,
        skinType: SkinType = .combination,
        skinConcerns: [SkinConcern] = [],
        knownAllergens: [String] = [],
        currentProducts: [String] = [],
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.userId = userId
        self.skinType = skinType
        self.skinConcerns = skinConcerns
        self.knownAllergens = knownAllergens
        self.currentProducts = currentProducts
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum SkinType: String, Codable, CaseIterable {
    case oily        = "oily"
    case dry         = "dry"
    case combination = "combination"
    case normal      = "normal"
    case sensitive   = "sensitive"

    var displayName: String {
        switch self {
        case .oily:        return "Oily"
        case .dry:         return "Dry"
        case .combination: return "Combination"
        case .normal:      return "Normal"
        case .sensitive:   return "Sensitive"
        }
    }

    var description: String {
        switch self {
        case .oily:        return "Produces a lot of sebum, tends to shine"
        case .dry:         return "Feels tight, may flake"
        case .combination: return "Oily T-zone, drier cheeks"
        case .normal:      return "Balanced skin without major issues"
        case .sensitive:   return "Reacts easily to products and environment"
        }
    }

    var systemImage: String {
        switch self {
        case .oily:        return "drop.fill"
        case .dry:         return "wind"
        case .combination: return "circle.lefthalf.filled"
        case .normal:      return "checkmark.circle.fill"
        case .sensitive:   return "heart.circle.fill"
        }
    }
}

enum SkinConcern: String, Codable, CaseIterable {
    case acne              = "acne"
    case blackheads        = "blackheads"
    case largePores        = "large_pores"
    case redness           = "redness"
    case hyperpigmentation = "hyperpigmentation"
    case wrinkles          = "wrinkles"
    case dullness          = "dullness"
    case sensitivity       = "sensitivity"

    var displayName: String {
        switch self {
        case .acne:              return "Acne"
        case .blackheads:        return "Blackheads"
        case .largePores:        return "Large pores"
        case .redness:           return "Redness"
        case .hyperpigmentation: return "Hyperpigmentation"
        case .wrinkles:          return "Wrinkles"
        case .dullness:          return "Dull skin"
        case .sensitivity:       return "Sensitivity"
        }
    }

    var systemImage: String {
        switch self {
        case .acne:              return "circle.dotted"
        case .blackheads:        return "circle.fill"
        case .largePores:        return "circle.dashed"
        case .redness:           return "waveform.path"
        case .hyperpigmentation: return "square.on.square.dashed"
        case .wrinkles:          return "line.3.horizontal.decrease"
        case .dullness:          return "moon.fill"
        case .sensitivity:       return "bolt.fill"
        }
    }
}
