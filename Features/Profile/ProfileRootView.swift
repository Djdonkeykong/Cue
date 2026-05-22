import SwiftUI

struct ProfileRootView: View {
    @EnvironmentObject private var authManager: AuthManager

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "person.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(SkinTheme.accent)
            Text("Profile")
                .font(.skin(.title2, weight: .bold))
                .foregroundStyle(SkinTheme.primaryText)

            Spacer()

            Button("Sign out") {
                Task { try? await authManager.signOut() }
            }
            .font(.skin(.callout))
            .foregroundStyle(SkinTheme.dangerColor)
            .padding(.bottom, 40)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SkinTheme.background)
    }
}
