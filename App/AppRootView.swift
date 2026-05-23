import SwiftUI

struct AppRootView: View {
    @ObservedObject var store: SkinStore
    @StateObject private var authManager = AuthManager.shared
    @AppStorage("cue.onboardingCompleted") private var onboardingCompleted = false

    var body: some View {
        Group {
            if !authManager.isReady {
                SplashView()
            } else if !onboardingCompleted {
                OnboardingRootView()
            } else if !authManager.isAuthenticated {
                OnboardingSignInView(onBack: nil, onSignUp: nil)
            } else {
                MainTabView()
            }
        }
        .environmentObject(store)
        .environmentObject(authManager)
        .tint(SkinTheme.accent)
    }
}
