import Foundation
import Supabase

@MainActor
final class CloudSyncManager {
    static let shared = CloudSyncManager()
    private init() {}

    // MARK: - Scan Results

    func uploadScanResult(_ result: ScanResult) async throws {
        guard let userId = AuthManager.shared.userId else { return }
        let payload = ScanResultPayload(from: result, userId: userId)
        try await SupabaseService.client
            .from(SupabaseService.Table.scanResults)
            .upsert(payload)
            .execute()
    }

    func fetchScanResults() async throws -> [ScanResult] {
        guard let userId = AuthManager.shared.userId else { return [] }
        let payloads: [ScanResultPayload] = try await SupabaseService.client
            .from(SupabaseService.Table.scanResults)
            .select()
            .eq("user_id", value: userId)
            .order("created_at", ascending: false)
            .execute()
            .value
        return payloads.map(\.scanResult)
    }

    // MARK: - Trigger Logs

    func uploadTriggerLog(_ log: TriggerLog) async throws {
        guard let userId = AuthManager.shared.userId else { return }
        let payload = TriggerLogPayload(from: log, userId: userId)
        try await SupabaseService.client
            .from(SupabaseService.Table.triggerLogs)
            .upsert(payload)
            .execute()
    }

    func fetchTriggerLogs(from startDate: Date, to endDate: Date) async throws -> [TriggerLog] {
        guard let userId = AuthManager.shared.userId else { return [] }
        let payloads: [TriggerLogPayload] = try await SupabaseService.client
            .from(SupabaseService.Table.triggerLogs)
            .select()
            .eq("user_id", value: userId)
            .gte("date", value: ISO8601DateFormatter().string(from: startDate))
            .lte("date", value: ISO8601DateFormatter().string(from: endDate))
            .order("date", ascending: false)
            .execute()
            .value
        return payloads.map(\.triggerLog)
    }

    // MARK: - Onboarding Profile

    func uploadOnboardingProfile(_ profile: UserOnboardingProfile) async throws {
        let payload = OnboardingProfilePayload(from: profile)
        try await SupabaseService.client
            .from("onboarding_profiles")
            .upsert(payload)
            .execute()
    }

    // MARK: - Skin Profile

    func uploadProfile(_ profile: SkinProfile) async throws {
        guard let userId = AuthManager.shared.userId else { return }
        let payload = SkinProfilePayload(from: profile, userId: userId)
        try await SupabaseService.client
            .from(SupabaseService.Table.skinProfiles)
            .upsert(payload)
            .execute()
    }

    func fetchProfile() async throws -> SkinProfile? {
        guard let userId = AuthManager.shared.userId else { return nil }
        let payloads: [SkinProfilePayload] = try await SupabaseService.client
            .from(SupabaseService.Table.skinProfiles)
            .select()
            .eq("user_id", value: userId)
            .limit(1)
            .execute()
            .value
        return payloads.first?.skinProfile
    }
}

// MARK: - Supabase Payloads
// Flat Codable structs for JSON serialization — keeps models clean.

private struct OnboardingProfilePayload: Codable {
    let id: String
    let userId: String
    let displayName: String?
    let gender: String
    let skinType: String
    let skinConcerns: [String]
    let concernSeverity: Int
    let concernDuration: String
    let ageRange: String
    let skincareRoutine: String
    let consistency: String
    let lifestyleFactors: [String]
    let sensitivityLevel: String
    let primaryGoal: String?
    let onboardingCompletedAt: String?

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

    init(from profile: UserOnboardingProfile) {
        let fmt = ISO8601DateFormatter()
        self.id                    = profile.id.uuidString
        self.userId                = profile.userId
        self.displayName           = profile.displayName
        self.gender                = profile.gender.rawValue
        self.skinType              = profile.skinType.rawValue
        self.skinConcerns          = profile.skinConcerns.map(\.rawValue)
        self.concernSeverity       = profile.concernSeverity
        self.concernDuration       = profile.concernDuration.rawValue
        self.ageRange              = profile.ageRange.rawValue
        self.skincareRoutine       = profile.skincareRoutine.rawValue
        self.consistency           = profile.consistency.rawValue
        self.lifestyleFactors      = profile.lifestyleFactors.map(\.rawValue)
        self.sensitivityLevel      = profile.sensitivityLevel.rawValue
        self.primaryGoal           = profile.primaryGoal
        self.onboardingCompletedAt = profile.onboardingCompletedAt.map { fmt.string(from: $0) }
    }
}

private struct ScanResultPayload: Codable {
    let id: String
    let userId: String
    let createdAt: String
    let productName: String?
    let rawOCRText: String
    let ingredientsJSON: String
    let imageFilename: String?

    enum CodingKeys: String, CodingKey {
        case id, productName = "product_name", userId = "user_id"
        case createdAt = "created_at", rawOCRText = "raw_ocr_text"
        case ingredientsJSON = "ingredients_json", imageFilename = "image_filename"
    }

    init(from result: ScanResult, userId: String) {
        self.id = result.id.uuidString
        self.userId = userId
        self.createdAt = ISO8601DateFormatter().string(from: result.createdAt)
        self.productName = result.productName
        self.rawOCRText = result.rawOCRText
        self.imageFilename = result.imageFilename
        let encoded = (try? JSONEncoder().encode(result.ingredients)) ?? Data()
        self.ingredientsJSON = String(data: encoded, encoding: .utf8) ?? "[]"
    }

    var scanResult: ScanResult {
        let ingredients = (try? JSONDecoder().decode(
            [ScannedIngredient].self,
            from: Data(ingredientsJSON.utf8)
        )) ?? []
        let formatter = ISO8601DateFormatter()
        return ScanResult(
            id: UUID(uuidString: id) ?? .init(),
            createdAt: formatter.date(from: createdAt) ?? .now,
            productName: productName,
            rawOCRText: rawOCRText,
            ingredients: ingredients,
            imageFilename: imageFilename
        )
    }
}

private struct TriggerLogPayload: Codable {
    let id: String
    let userId: String
    let date: String
    let dataJSON: String

    enum CodingKeys: String, CodingKey {
        case id, userId = "user_id", date, dataJSON = "data_json"
    }

    init(from log: TriggerLog, userId: String) {
        self.id = log.id.uuidString
        self.userId = userId
        self.date = ISO8601DateFormatter().string(from: log.date)
        let encoded = (try? JSONEncoder().encode(log)) ?? Data()
        self.dataJSON = String(data: encoded, encoding: .utf8) ?? "{}"
    }

    var triggerLog: TriggerLog {
        (try? JSONDecoder().decode(TriggerLog.self, from: Data(dataJSON.utf8))) ?? TriggerLog()
    }
}

private struct SkinProfilePayload: Codable {
    let id: String
    let userId: String
    let dataJSON: String

    enum CodingKeys: String, CodingKey {
        case id, userId = "user_id", dataJSON = "data_json"
    }

    init(from profile: SkinProfile, userId: String) {
        self.id = profile.id.uuidString
        self.userId = userId
        let encoded = (try? JSONEncoder().encode(profile)) ?? Data()
        self.dataJSON = String(data: encoded, encoding: .utf8) ?? "{}"
    }

    var skinProfile: SkinProfile? {
        try? JSONDecoder().decode(SkinProfile.self, from: Data(dataJSON.utf8))
    }
}
