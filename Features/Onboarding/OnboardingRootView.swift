import SwiftUI

struct OnboardingRootView: View {
    @EnvironmentObject private var authManager: AuthManager
    @State private var step: Step = .welcome

    private enum Step {
        case welcome
        case painPoint
        case auth
        case signIn
    }

    var body: some View {
        ZStack {
            SkinTheme.background.ignoresSafeArea()

            Group {
                switch step {
                case .welcome:
                    WelcomeView(
                        onContinue: { navigate(to: .painPoint) },
                        onSignIn: { navigate(to: .signIn) }
                    )
                    .transition(transition(for: .welcome))

                case .painPoint:
                    OnboardingPainPointView { navigate(to: .auth) }
                        .transition(transition(for: .painPoint))

                case .auth:
                    OnboardingAuthView(onBack: { navigate(to: .painPoint) })
                        .transition(transition(for: .auth))

                case .signIn:
                    OnboardingSignInView(
                        onBack: { navigate(to: .welcome) },
                        onSignUp: { navigate(to: .auth) }
                    )
                    .transition(transition(for: .signIn))
                }
            }
            .animation(.spring(duration: 0.4), value: step)
        }
    }

    private func navigate(to next: Step) {
        step = next
    }

    private func transition(for s: Step) -> AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
}
