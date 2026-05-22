import SwiftUI

struct AppRootView: View {
    @ObservedObject var store: SkinStore
    @StateObject private var authManager = AuthManager.shared
    @AppStorage("cue.onboardingCompleted") private var onboardingCompleted = false

    var body: some View {
        Group {
            if !authManager.isReady {
                SplashView()
            } else if !authManager.isAuthenticated {
                OnboardingRootView()
            } else if !onboardingCompleted {
                OnboardingQuizRootView()
            } else {
                MainTabView()
            }
        }
        .environmentObject(store)
        .environmentObject(authManager)
        .tint(SkinTheme.accent)
    }
}
