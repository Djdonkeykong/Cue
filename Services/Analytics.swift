import Foundation

// Stub — koble til PostHog eller annen analytics-provider her
enum Analytics {
    static func setup() {}
    static func track(_ event: String, properties: [String: Any] = [:]) {}
}
