import Foundation

struct TriggerLog: Identifiable, Codable {
    let id: UUID
    let date: Date                   // normalized to start-of-day
    var skinCondition: Int           // 1 (klar) – 5 (kraftig utbrudd)
    var hadBreakout: Bool
    var sleep: SleepEntry?
    var stress: Int?                 // 1–5
    var waterIntakeLiters: Double?
    var foods: [FoodEntry]
    var productsUsed: [String]       // product names (links to ScanResult.productName)
    var alcoholUnits: Double?
    var humidity: Double?            // % — auto-fetched from weather API
    var notes: String?

    init(
        id: UUID = .init(),
        date: Date = Calendar.current.startOfDay(for: .now),
        skinCondition: Int = 1,
        hadBreakout: Bool = false,
        sleep: SleepEntry? = nil,
        stress: Int? = nil,
        waterIntakeLiters: Double? = nil,
        foods: [FoodEntry] = [],
        productsUsed: [String] = [],
        alcoholUnits: Double? = nil,
        humidity: Double? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.date = date
        self.skinCondition = skinCondition
        self.hadBreakout = hadBreakout
        self.sleep = sleep
        self.stress = stress
        self.waterIntakeLiters = waterIntakeLiters
        self.foods = foods
        self.productsUsed = productsUsed
        self.alcoholUnits = alcoholUnits
        self.humidity = humidity
        self.notes = notes
    }
}

struct SleepEntry: Codable {
    var hours: Double
    var quality: Int   // 1–5

    var qualityLabel: String {
        switch quality {
        case 1: return "Veldig darlig"
        case 2: return "Darlig"
        case 3: return "OK"
        case 4: return "Bra"
        default: return "Veldig bra"
        }
    }
}

struct FoodEntry: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: FoodCategory

    init(id: UUID = .init(), name: String, category: FoodCategory = .other) {
        self.id = id
        self.name = name
        self.category = category
    }
}

enum FoodCategory: String, Codable, CaseIterable {
    case dairy      = "dairy"
    case sugar      = "sugar"
    case gluten     = "gluten"
    case alcohol    = "alcohol"
    case spicy      = "spicy"
    case processed  = "processed"
    case vegetable  = "vegetable"
    case fruit      = "fruit"
    case protein    = "protein"
    case other      = "other"

    var displayName: String {
        switch self {
        case .dairy:     return "Melkeprodukter"
        case .sugar:     return "Sukker"
        case .gluten:    return "Gluten"
        case .alcohol:   return "Alkohol"
        case .spicy:     return "Sterk mat"
        case .processed: return "Prosessert mat"
        case .vegetable: return "Gronnsaker"
        case .fruit:     return "Frukt"
        case .protein:   return "Protein"
        case .other:     return "Annet"
        }
    }

    var systemImage: String {
        switch self {
        case .dairy:     return "drop.fill"
        case .sugar:     return "cube.fill"
        case .gluten:    return "birthday.cake"
        case .alcohol:   return "wineglass"
        case .spicy:     return "flame.fill"
        case .processed: return "takeoutbag.and.cup.and.straw.fill"
        case .vegetable: return "leaf.fill"
        case .fruit:     return "apple.logo"
        case .protein:   return "fork.knife"
        case .other:     return "circle.fill"
        }
    }
}
