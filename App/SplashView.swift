import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            SkinTheme.background.ignoresSafeArea()
            Image(systemName: "drop.circle")
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(SkinTheme.accent)
        }
    }
}
