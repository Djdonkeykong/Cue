import SwiftUI

struct OnboardingRootView: View {
    @State private var page = 0

    var body: some View {
        ZStack {
            SkinTheme.background.ignoresSafeArea()

            Group {
                switch page {
                case 0:
                    OnboardingWelcomeView { page = 1 }
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal:   .move(edge: .leading).combined(with: .opacity)
                        ))
                case 1:
                    OnboardingPainPointView { page = 2 }
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal:   .move(edge: .leading).combined(with: .opacity)
                        ))
                default:
                    OnboardingSignInView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal:   .move(edge: .leading).combined(with: .opacity)
                        ))
                }
            }
            .animation(.spring(duration: 0.4), value: page)
        }
    }
}
