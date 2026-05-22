import Foundation
import Supabase

enum SupabaseService {
    static let client = SupabaseClient(
        supabaseURL: URL(string: "https://islfmfwfwjqrzfalomhc.supabase.co")!,
        supabaseKey: "sb_publishable_wz0Ohb_ppi0_ekd5kL9ZOw_6JatqHp3"
    )
}

// MARK: - Table names
extension SupabaseService {
    enum Table {
        static let scanResults  = "scan_results"
        static let triggerLogs  = "trigger_logs"
        static let skinProfiles = "skin_profiles"
        static let insights     = "insights"
    }
}
