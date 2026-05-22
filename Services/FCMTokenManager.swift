import Foundation

actor FCMTokenManager {
    static let shared = FCMTokenManager()
    private init() {}

    func upload(_ token: String) async {
        guard let userId = await AuthManager.shared.userId else { return }
        do {
            try await SupabaseService.client
                .from("fcm_tokens")
                .upsert(["user_id": userId, "token": token, "platform": "ios"])
                .execute()
        } catch {
            // Non-critical — push notifications will still work on next launch
        }
    }
}
