import Foundation
import Combine

@MainActor
final class SkinStore: ObservableObject {
    @Published var scanHistory: [ScanResult] = []
    @Published var triggerLogs: [TriggerLog] = []
    @Published var userProfile: SkinProfile?
    @Published var isPro: Bool = false

    private let cloudSync = CloudSyncManager.shared

    init() {
        Task { await load() }
    }

    func load() async {
        // Loaded by feature-specific managers — this store is the single
        // source of truth passed down through the environment.
    }
}
