import Foundation

// In-memory lookup built from the bundled comedogenic_db.json at launch.
// Usage: IngredientDatabase.shared.lookup(inci: "isopropyl myristate")
@MainActor
final class IngredientDatabase {
    static let shared = IngredientDatabase()

    private var byINCI: [String: Ingredient] = [:]  // lowercased INCI key

    private init() {
        load()
    }

    // MARK: - Lookup

    func lookup(inci: String) -> Ingredient? {
        byINCI[inci.lowercased().trimmingCharacters(in: .whitespaces)]
    }

    // Returns best match or an unknown-rated placeholder
    func lookupOrUnknown(rawToken: String) -> ScannedIngredient {
        let normalized = normalize(rawToken)
        let ingredient = lookup(inci: normalized) ?? Ingredient(
            inci: normalized,
            comedogenicRating: -1,
            category: .other
        )
        return ScannedIngredient(ingredient: ingredient, rawText: rawToken)
    }

    // MARK: - Loading

    private func load() {
        guard
            let url = Bundle.main.url(forResource: "comedogenic_db", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let entries = try? JSONDecoder().decode([IngredientDBEntry].self, from: data)
        else { return }

        for entry in entries {
            let ingredient = Ingredient(
                inci: entry.inci,
                commonName: entry.commonName,
                comedogenicRating: entry.comedogenicRating,
                category: IngredientCategory(rawValue: entry.category) ?? .other
            )
            byINCI[entry.inci.lowercased()] = ingredient
            if let alias = entry.alias {
                byINCI[alias.lowercased()] = ingredient
            }
        }
    }

    // MARK: - Normalization

    // Strips punctuation, collapses whitespace, lowercases
    func normalize(_ token: String) -> String {
        token
            .lowercased()
            .components(separatedBy: .punctuationCharacters).joined(separator: " ")
            .components(separatedBy: .whitespaces).filter { !$0.isEmpty }.joined(separator: " ")
    }

    // Splits raw OCR ingredient text into individual tokens
    func tokenize(_ raw: String) -> [String] {
        raw
            .components(separatedBy: CharacterSet(charactersIn: ",\n"))
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    // Full pipeline: raw OCR text -> ScannedIngredient list
    func parse(ocrText: String) -> [ScannedIngredient] {
        tokenize(ocrText).map { lookupOrUnknown(rawToken: $0) }
    }
}

// MARK: - JSON schema for bundled DB

private struct IngredientDBEntry: Codable {
    let inci: String
    let commonName: String?
    let comedogenicRating: Int
    let category: String
    let alias: String?

    enum CodingKeys: String, CodingKey {
        case inci, commonName = "common_name"
        case comedogenicRating = "comedogenic_rating"
        case category, alias
    }
}
