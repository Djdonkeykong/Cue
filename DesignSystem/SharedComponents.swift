import SwiftUI

// MARK: - Back button

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(SkinTheme.primaryText)
                .frame(width: 38, height: 38)
                .background(SkinTheme.surface, in: Circle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Primary button

struct PrimaryButton: View {
    let label: String
    let color: Color
    let isEnabled: Bool
    let action: () -> Void

    init(
        _ label: String,
        color: Color = SkinTheme.accent,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.color = color
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        } label: {
            Text(label)
                .font(.skin(.body, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isEnabled ? color : color.opacity(0.35), in: Capsule())
                .padding(.horizontal, 24)
        }
        .disabled(!isEnabled)
        .buttonStyle(.plain)
    }
}
