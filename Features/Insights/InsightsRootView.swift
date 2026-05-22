import SwiftUI

struct InsightsRootView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "sparkles")
                .font(.system(size: 64))
                .foregroundStyle(SkinTheme.accent)
            Text("AI Insights")
                .font(.skin(.title2, weight: .bold))
                .foregroundStyle(SkinTheme.primaryText)
            Text("Correlations between your lifestyle and skin condition will appear here once you have enough log data.")
                .font(.skin(.callout))
                .foregroundStyle(SkinTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
        .navigationTitle("Insights")
        .navigationBarTitleDisplayMode(.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SkinTheme.background)
    }
}
