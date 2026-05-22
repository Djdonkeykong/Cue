import Foundation

// Represents a single AI-generated pattern insight (Pro feature)
struct Insight: Identifiable, Codable {
    let id: UUID
    let generatedAt: Date
    let type: InsightType
    let title: String
    let body: String
    let confidence: Double       // 0.0–1.0
    let triggerFactor: TriggerFactor?
    let daysToBreakout: Int?     // "Du far utbrudd X dager etter..."

    init(
        id: UUID = .init(),
        generatedAt: Date = .now,
        type: InsightType,
        title: String,
        body: String,
        confidence: Double,
        triggerFactor: TriggerFactor? = nil,
        daysToBreakout: Int? = nil
    ) {
        self.id = id
        self.generatedAt = generatedAt
        self.type = type
        self.title = title
        self.body = body
        self.confidence = confidence
        self.triggerFactor = triggerFactor
        self.daysToBreakout = daysToBreakout
    }

    var confidenceLabel: String {
        switch confidence {
        case 0..<0.5:  return "Svakt monster"
        case 0.5..<0.75: return "Tydelig monster"
        default:       return "Sterkt monster"
        }
    }
}

enum InsightType: String, Codable {
    case sleepCorrelation   = "sleep_correlation"
    case stressCorrelation  = "stress_correlation"
    case foodCorrelation    = "food_correlation"
    case productCorrelation = "product_correlation"
    case weatherCorrelation = "weather_correlation"
    case cyclePattern       = "cycle_pattern"

    var systemImage: String {
        switch self {
        case .sleepCorrelation:   return "moon.zzz.fill"
        case .stressCorrelation:  return "brain.head.profile"
        case .foodCorrelation:    return "fork.knife"
        case .productCorrelation: return "drop.fill"
        case .weatherCorrelation: return "cloud.rain.fill"
        case .cyclePattern:       return "arrow.trianglehead.clockwise"
        }
    }
}

enum TriggerFactor: String, Codable {
    case sleep    = "sleep"
    case stress   = "stress"
    case food     = "food"
    case product  = "product"
    case humidity = "humidity"
    case alcohol  = "alcohol"
}
