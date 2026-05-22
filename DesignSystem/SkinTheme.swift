import SwiftUI
import UIKit

enum SkinTheme {
    // MARK: - Backgrounds
    static let background = adaptiveColor(
        light: UIColor(red: 0.961, green: 0.941, blue: 0.922, alpha: 1),  // #F5F0EB
        dark:  UIColor(red: 0.082, green: 0.071, blue: 0.063, alpha: 1)   // #151209
    )
    static let surface = adaptiveColor(
        light: UIColor(red: 0.992, green: 0.976, blue: 0.965, alpha: 0.96), // #FDF9F6
        dark:  UIColor(red: 0.122, green: 0.110, blue: 0.098, alpha: 0.94)  // #1F1C19
    )
    static let elevatedSurface = adaptiveColor(
        light: UIColor(red: 1.000, green: 0.992, blue: 0.984, alpha: 1),  // #FFFDF9
        dark:  UIColor(red: 0.161, green: 0.145, blue: 0.129, alpha: 1)   // #292521
    )
    static let inputSurface = adaptiveColor(
        light: UIColor(red: 0.937, green: 0.918, blue: 0.898, alpha: 1),  // #EEEAe5
        dark:  UIColor(red: 0.196, green: 0.176, blue: 0.157, alpha: 1)   // #322D28
    )

    // MARK: - Glass support (borders, overlays)
    static let surfaceBorder = adaptiveColor(
        light: UIColor.white.withAlphaComponent(0.72),
        dark:  UIColor.white.withAlphaComponent(0.10)
    )
    static let glassOverlay = adaptiveColor(
        light: UIColor(red: 1.0, green: 0.96, blue: 0.92, alpha: 0.18),
        dark:  UIColor.white.withAlphaComponent(0.05)
    )
    static let shadow = adaptiveColor(
        light: UIColor(red: 0.25, green: 0.18, blue: 0.12, alpha: 0.06),
        dark:  UIColor.black.withAlphaComponent(0.28)
    )

    // MARK: - Text
    static let primaryText   = Color(uiColor: .label)
    static let secondaryText = Color(uiColor: .secondaryLabel)
    static let tertiaryText  = Color(uiColor: .tertiaryLabel)

    // MARK: - Brand
    /// Terracotta — primary accent, buttons, highlights
    static let accent = adaptiveColor(
        light: UIColor(red: 0.769, green: 0.518, blue: 0.353, alpha: 1),  // #C4845A
        dark:  UIColor(red: 0.871, green: 0.624, blue: 0.463, alpha: 1)   // #DE9F76
    )
    /// Softer secondary tint — tags, chips, backgrounds
    static let accentSoft = adaptiveColor(
        light: UIColor(red: 0.933, green: 0.859, blue: 0.800, alpha: 1),  // #EDDBCC
        dark:  UIColor(red: 0.239, green: 0.176, blue: 0.133, alpha: 1)   // #3D2D22
    )
    /// Deep warm brown — dark buttons, prominent surfaces
    static let darkSurface = adaptiveColor(
        light: UIColor(red: 0.157, green: 0.118, blue: 0.086, alpha: 1),  // #281E16
        dark:  UIColor(red: 0.161, green: 0.145, blue: 0.129, alpha: 1)   // #292521
    )

    // MARK: - Semantic
    static let safeColor = adaptiveColor(
        light: UIColor(red: 0.133, green: 0.631, blue: 0.329, alpha: 1),  // #22A154
        dark:  UIColor(red: 0.224, green: 0.773, blue: 0.455, alpha: 1)   // #39C574
    )
    static let warningColor = adaptiveColor(
        light: UIColor(red: 0.929, green: 0.631, blue: 0.118, alpha: 1),  // #EDA11E
        dark:  UIColor(red: 1.000, green: 0.737, blue: 0.255, alpha: 1)   // #FFBC41
    )
    static let dangerColor = adaptiveColor(
        light: UIColor(red: 0.851, green: 0.235, blue: 0.200, alpha: 1),  // #D93C33
        dark:  UIColor(red: 1.000, green: 0.420, blue: 0.388, alpha: 1)   // #FF6B63
    )

    // MARK: - Comedogenic rating colors (0–5 scale)
    static func comedogenicColor(rating: Int) -> Color {
        switch rating {
        case 0:    return Color(uiColor: safeColor.uiColor)
        case 1:    return Color(red: 0.55, green: 0.76, blue: 0.29)
        case 2:    return Color(red: 0.93, green: 0.78, blue: 0.22)
        case 3:    return Color(red: 0.95, green: 0.60, blue: 0.18)
        case 4:    return Color(red: 0.90, green: 0.36, blue: 0.22)
        default:   return Color(uiColor: dangerColor.uiColor)
        }
    }

    // MARK: - Private
    static func adaptiveColor(light: UIColor, dark: UIColor) -> Color {
        Color(
            uiColor: UIColor { $0.userInterfaceStyle == .dark ? dark : light }
        )
    }
}

// Expose UIColor directly when needed for UIKit bridging
private extension Color {
    var uiColor: UIColor { UIColor(self) }
}

// MARK: - SkinTheme UIColor helpers
extension SkinTheme {
    static var accentUIColor: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: 0.871, green: 0.624, blue: 0.463, alpha: 1)
            : UIColor(red: 0.769, green: 0.518, blue: 0.353, alpha: 1)
        }
    }
    static var backgroundUIColor: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: 0.082, green: 0.071, blue: 0.063, alpha: 1)
            : UIColor(red: 0.961, green: 0.941, blue: 0.922, alpha: 1)
        }
    }
}

// MARK: - Font
extension Font {
    static func skin(_ style: TextStyle, weight: Weight = .regular) -> Font {
        .system(style, design: .default, weight: weight)
    }
}
