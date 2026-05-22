import Foundation
import Supabase
import GoogleSignIn

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published private(set) var isAuthenticated = false
    @Published private(set) var isLoading = true
    @Published private(set) var userId: String?

    private init() {
        Task { await checkSession() }
    }

    func checkSession() async {
        defer { isLoading = false }
        do {
            let session = try await SupabaseService.client.auth.session
            userId = session.user.id.uuidString
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }

    func signInWithGoogle() async throws {
        guard let topVC = await UIApplication.shared.topViewController() else { return }
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        guard let idToken = result.user.idToken?.tokenString else { return }
        let accessToken = result.user.accessToken.tokenString
        try await SupabaseService.client.auth.signInWithIdToken(
            credentials: .init(provider: .google, idToken: idToken, accessToken: accessToken)
        )
        await checkSession()
    }

    func signOut() async throws {
        try await SupabaseService.client.auth.signOut()
        userId = nil
        isAuthenticated = false
    }
}

// MARK: - UIApplication helper
private extension UIApplication {
    func topViewController() async -> UIViewController? {
        await MainActor.run {
            connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .first { $0.isKeyWindow }?
                .rootViewController?
                .topMost
        }
    }
}

private extension UIViewController {
    var topMost: UIViewController {
        if let presented = presentedViewController { return presented.topMost }
        if let nav = self as? UINavigationController { return nav.visibleViewController?.topMost ?? self }
        if let tab = self as? UITabBarController { return tab.selectedViewController?.topMost ?? self }
        return self
    }
}
