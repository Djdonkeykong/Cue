import Foundation

struct SkinProfile: Identifiable, Codable {
    let id: UUID
    var userId: String
    var skinType: SkinType
    var skinConcerns: [SkinConcern]
    var knownAllergens: [String]
    var currentProducts: [String]   // product names in active routine
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
        case .oily:        return "Fetthud"
        case .dry:         return "Torr hud"
        case .combination: return "Kombinasjonshud"
        case .normal:      return "Normal hud"
        case .sensitive:   return "Sensitiv hud"
        }
    }

    var description: String {
        switch self {
        case .oily:        return "Huden produserer mye talg og skinner lett"
        case .dry:         return "Huden foles stram og kan flasse"
        case .combination: return "Fet T-sone, torrere kinn"
        case .normal:      return "Balansert hud uten store problemer"
        case .sensitive:   return "Reagerer lett pa produkter og miljopavirkning"
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
    case acne            = "acne"
    case blackheads      = "blackheads"
    case largePores      = "large_pores"
    case redness         = "redness"
    case hyperpigmentation = "hyperpigmentation"
    case wrinkles        = "wrinkles"
    case dullness        = "dullness"
    case sensitivity     = "sensitivity"

    var displayName: String {
        switch self {
        case .acne:              return "Akne"
        case .blackheads:        return "Pormasker"
        case .largePores:        return "Store porer"
        case .redness:           return "Rodnhet"
        case .hyperpigmentation: return "Misfarginger"
        case .wrinkles:          return "Rynker"
        case .dullness:          return "Dull hud"
        case .sensitivity:       return "Sensitivitet"
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
