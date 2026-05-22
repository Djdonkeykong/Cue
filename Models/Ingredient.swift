import Foundation

struct Ingredient: Identifiable, Codable, Hashable {
    let id: UUID
    let inci: String           // INCI name — canonical key used against DB
    let commonName: String?
    let comedogenicRating: Int // 0–5; -1 = unknown
    let category: IngredientCategory

    init(
        id: UUID = .init(),
        inci: String,
        commonName: String? = nil,
        comedogenicRating: Int,
        category: IngredientCategory = .other
    ) {
        self.id = id
        self.inci = inci
        self.commonName = commonName
        self.comedogenicRating = comedogenicRating
        self.category = category
    }

    var displayName: String { commonName ?? inci }

    var ratingLabel: String {
        switch comedogenicRating {
        case 0:    return "Ikke poreblokerende"
        case 1:    return "Svak risiko"
        case 2:    return "Lav risiko"
        case 3:    return "Moderat"
        case 4:    return "Hoy risiko"
        case 5:    return "Sterk poreblokker"
        default:   return "Ukjent"
        }
    }

    var isProblematic: Bool { comedogenicRating >= 3 }
    var isUnknown: Bool     { comedogenicRating == -1 }
}

enum IngredientCategory: String, Codable, CaseIterable {
    case emollient      = "emollient"
    case humectant      = "humectant"
    case occlusive      = "occlusive"
    case surfactant     = "surfactant"
    case preservative   = "preservative"
    case fragrance      = "fragrance"
    case activeAgent    = "active_agent"
    case silicone       = "silicone"
    case wax            = "wax"
    case oil            = "oil"
    case other          = "other"

    var displayName: String {
        switch self {
        case .emollient:    return "Emollient"
        case .humectant:    return "Fuktighetsbinder"
        case .occlusive:    return "Okklusiv"
        case .surfactant:   return "Overflateaktiv"
        case .preservative: return "Konserveringsmiddel"
        case .fragrance:    return "Parfyme"
        case .activeAgent:  return "Aktivt stoff"
        case .silicone:     return "Silikon"
        case .wax:          return "Voks"
        case .oil:          return "Olje"
        case .other:        return "Annet"
        }
    }
}
