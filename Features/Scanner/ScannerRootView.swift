import SwiftUI

struct ScannerRootView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "barcode.viewfinder")
                .font(.system(size: 64))
                .foregroundStyle(SkinTheme.accent)
            Text("Ingredient Analysis")
                .font(.skin(.title2, weight: .bold))
                .foregroundStyle(SkinTheme.primaryText)
            Text("Scan your product's ingredient list to check for comedogenic content.")
                .font(.skin(.callout))
                .foregroundStyle(SkinTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
        .navigationTitle("Scanner")
        .navigationBarTitleDisplayMode(.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SkinTheme.background)
    }
}
