import SwiftUI

struct ScannerRootView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "barcode.viewfinder")
                .font(.system(size: 64))
                .foregroundStyle(SkinTheme.accent)
            Text("Ingrediensanalyse")
                .font(.skin(.title2, weight: .bold))
                .foregroundStyle(SkinTheme.primaryText)
            Text("Skann ingredienslisten pa produktet ditt for a sjekke komedogent innhold.")
                .font(.skin(.callout))
                .foregroundStyle(SkinTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
        .navigationTitle("Skann")
        .navigationBarTitleDisplayMode(.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SkinTheme.background)
    }
}
