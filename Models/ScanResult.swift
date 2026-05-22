import Foundation

struct ScanResult: Identifiable, Codable {
    let id: UUID
    let createdAt: Date
    var productName: String?
    let rawOCRText: String
    let ingredients: [ScannedIngredient]
    var imageFilename: String?   // stored locally in app's Documents/scans/

    init(
        id: UUID = .init(),
        createdAt: Date = .now,
        productName: String? = nil,
        rawOCRText: String,
        ingredients: [ScannedIngredient],
        imageFilename: String? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.productName = productName
        self.rawOCRText = rawOCRText
        self.ingredients = ingredients
        self.imageFilename = imageFilename
    }

    // Worst comedogenic rating among all known ingredients
    var overallRating: Int {
        let known = ingredients.filter { !$0.ingredient.isUnknown }
        return known.map(\.ingredient.comedogenicRating).max() ?? -1
    }

    var problematicIngredients: [ScannedIngredient] {
        ingredients.filter { $0.ingredient.isProblematic }
    }

    var unknownIngredients: [ScannedIngredient] {
        ingredients.filter { $0.ingredient.isUnknown }
    }

    var ratingLabel: String {
        switch overallRating {
        case 0...1: return "Trygt"
        case 2:     return "Lav risiko"
        case 3:     return "Moderat"
        case 4...5: return "Poreblokker"
        default:    return "Ukjent"
        }
    }
}

struct ScannedIngredient: Identifiable, Codable {
    let id: UUID
    let ingredient: Ingredient
    let rawText: String    // original token from OCR before normalization

    init(id: UUID = .init(), ingredient: Ingredient, rawText: String) {
        self.id = id
        self.ingredient = ingredient
        self.rawText = rawText
    }
}
