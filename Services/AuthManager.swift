import AuthenticationServices
import CryptoKit
import Foundation
import GoogleSignIn
import Supabase

enum AuthError: LocalizedError {
    case missingIdentityToken
    case appleSignInCancelled
    case appleSignInFailed(Error)
    case googleSignInCancelled
    case sessionNotEstablished

    var isCancelled: Bool {
        switch self {
        case .appleSignInCancelled, .googleSignInCancelled: return true
        default: return false
        }
    }

    var errorDescription: String? {
        switch self {
        case .missingIdentityToken:    return "Unable to complete sign in. Please try again."
        case .appleSignInCancelled, .googleSignInCancelled: return nil
        case .appleSignInFailed(let e): return e.localizedDescription
        case .sessionNotEstablished:   return "Session could not be established. Please try again."
        }
    }
}

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published private(set) var isAuthenticated = false
    @Published private(set) var isReady = false
    @Published private(set) var userId: String?
    @Published private(set) var supabaseUserEmail: String?

    private var appleCoordinator: AppleSignInCoordinator?

    private init() {
        Task { await checkSession() }
    }

    func checkSession() async {
        defer { isReady = true }
        do {
            let session = try await SupabaseService.client.auth.session
            userId = session.user.id.uuidString
            supabaseUserEmail = session.user.email
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }

    // MARK: - Google

    func signInWithGoogle() async throws {
        guard let topVC = topViewController() else { return }
        let result: GIDSignInResult
        do {
            result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        } catch let error as GIDSignInError where error.code == .canceled {
            throw AuthError.googleSignInCancelled
        }
        guard let idToken = result.user.idToken?.tokenString else { return }
        let accessToken = result.user.accessToken.tokenString
        try await SupabaseService.client.auth.signInWithIdToken(
            credentials: .init(provider: .google, idToken: idToken, accessToken: accessToken)
        )
        await checkSession()
    }

    // MARK: - Apple

    func signInWithApple() async throws {
        let nonce = randomNonceString()
        let hashedNonce = sha256(nonce)

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = hashedNonce

        let coordinator = AppleSignInCoordinator()
        appleCoordinator = coordinator

        let authorization = try await withCheckedThrowingContinuation { continuation in
            coordinator.continuation = continuation
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = coordinator
            controller.presentationContextProvider = coordinator
            controller.performRequests()
        }
        appleCoordinator = nil

        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = credential.identityToken,
              let idToken = String(data: tokenData, encoding: .utf8) else {
            throw AuthError.missingIdentityToken
        }

        try await SupabaseService.client.auth.signInWithIdToken(
            credentials: .init(provider: .apple, idToken: idToken, nonce: nonce)
        )
        await checkSession()
    }

    // MARK: - Email OTP

    func sendOTP(email: String, shouldCreateUser: Bool) async throws {
        try await SupabaseService.client.auth.signInWithOTP(
            email: email,
            shouldCreateUser: shouldCreateUser
        )
    }

    func verifyOTP(email: String, token: String) async throws {
        try await SupabaseService.client.auth.verifyOTP(
            email: email,
            token: token,
            type: .email
        )
        await checkSession()
    }

    // MARK: - Sign out

    func signOut() async throws {
        try await SupabaseService.client.auth.signOut()
        userId = nil
        supabaseUserEmail = nil
        isAuthenticated = false
    }

    // MARK: - Helpers

    private func topViewController() -> UIViewController? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }?
            .rootViewController?
            .topMost
    }

    private func randomNonceString(length: Int = 32) -> String {
        var bytes = [UInt8](repeating: 0, count: length)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        return bytes.map { String(format: "%02x", $0) }.joined()
    }

    private func sha256(_ input: String) -> String {
        let data = Data(input.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - Apple Sign-In coordinator

private final class AppleSignInCoordinator: NSObject,
    ASAuthorizationControllerDelegate,
    ASAuthorizationControllerPresentationContextProviding
{
    var continuation: CheckedContinuation<ASAuthorization, Error>?

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow } ?? UIWindow()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        continuation?.resume(returning: authorization)
        continuation = nil
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let e = error as? ASAuthorizationError, e.code == .canceled {
            continuation?.resume(throwing: AuthError.appleSignInCancelled)
        } else {
            continuation?.resume(throwing: AuthError.appleSignInFailed(error))
        }
        continuation = nil
    }
}

// MARK: - UIViewController helper

private extension UIViewController {
    var topMost: UIViewController {
        if let presented = presentedViewController { return presented.topMost }
        if let nav = self as? UINavigationController { return nav.visibleViewController?.topMost ?? self }
        if let tab = self as? UITabBarController { return tab.selectedViewController?.topMost ?? self }
        return self
    }
}
