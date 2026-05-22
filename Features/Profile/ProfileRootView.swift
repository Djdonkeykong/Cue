import SwiftUI

struct ProfileRootView: View {
    @EnvironmentObject private var authManager: AuthManager

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "person.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(SkinTheme.accent)
            Text("Profil")
                .font(.skin(.title2, weight: .bold))
                .foregroundStyle(SkinTheme.primaryText)

            Spacer()

            Button("Logg ut") {
                Task { try? await authManager.signOut() }
            }
            .font(.skin(.callout))
            .foregroundStyle(SkinTheme.dangerColor)
            .padding(.bottom, 40)
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SkinTheme.background)
    }
}
