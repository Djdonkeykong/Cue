import SwiftUI

struct TrackerRootView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "chart.dots.scatter")
                .font(.system(size: 64))
                .foregroundStyle(SkinTheme.accent)
            Text("Trigger Tracker")
                .font(.skin(.title2, weight: .bold))
                .foregroundStyle(SkinTheme.primaryText)
            Text("Log your skin, food, sleep, and stress to find what's affecting your skin.")
                .font(.skin(.callout))
                .foregroundStyle(SkinTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
        .navigationTitle("Tracker")
        .navigationBarTitleDisplayMode(.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SkinTheme.background)
    }
}
