import SwiftUI
import UIKit

enum SkinTheme {
    // MARK: - Backgrounds
    static let background = adaptiveColor(
        light: UIColor(red: 0.992, green: 0.910, blue: 0.949, alpha: 1),  // #FDE8F2
        dark:  UIColor(red: 0.078, green: 0.063, blue: 0.071, alpha: 1)   // #141012
    )
    static let surface = adaptiveColor(
        light: UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.96),
        dark:  UIColor(red: 0.118, green: 0.098, blue: 0.110, alpha: 0.94)  // #1E191C
    )
    static let elevatedSurface = adaptiveColor(
        light: UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1),
        dark:  UIColor(red: 0.157, green: 0.133, blue: 0.145, alpha: 1)   // #282225
    )
    static let inputSurface = adaptiveColor(
        light: UIColor(red: 0.969, green: 0.910, blue: 0.945, alpha: 1),  // #F7E8F1
        dark:  UIColor(red: 0.192, green: 0.157, blue: 0.180, alpha: 1)   // #31282E
    )

    // MARK: - Glass support
    static let surfaceBorder = adaptiveColor(
        light: UIColor.white.withAlphaComponent(0.72),
        dark:  UIColor.white.withAlphaComponent(0.10)
    )
    static let glassOverlay = adaptiveColor(
        light: UIColor(red: 0.969, green: 0.784, blue: 0.898, alpha: 0.18),
        dark:  UIColor.white.withAlphaComponent(0.05)
    )
    static let shadow = adaptiveColor(
        light: UIColor(red: 0.200, green: 0.082, blue: 0.157, alpha: 0.08),
        dark:  UIColor.black.withAlphaComponent(0.28)
    )

    // MARK: - Text
    static let primaryText   = Color(uiColor: .label)
    static let secondaryText = Color(uiColor: .secondaryLabel)
    static let tertiaryText  = Color(uiColor: .tertiaryLabel)
    static let black         = Color(red: 0.055, green: 0.055, blue: 0.055)  // #0E0E0E

    // MARK: - Brand
    /// Pastel pink - primary brand color, card backgrounds
    static let primary = adaptiveColor(
        light: UIColor(red: 0.969, green: 0.784, blue: 0.898, alpha: 1),  // #F7C8E5
        dark:  UIColor(red: 0.400, green: 0.180, blue: 0.314, alpha: 1)   // #662E50
    )
    /// Deep pink - buttons, CTA, active states
    static let primaryDeep = adaptiveColor(
        light: UIColor(red: 0.831, green: 0.412, blue: 0.604, alpha: 1),  // #D4699A
        dark:  UIColor(red: 0.910, green: 0.549, blue: 0.737, alpha: 1)   // #E88CBD
    )
    /// Soft pink tint - chips, tags, subtle fills
    static let primarySoft = adaptiveColor(
        light: UIColor(red: 0.988, green: 0.929, blue: 0.965, alpha: 1),  // #FCEDF6
        dark:  UIColor(red: 0.235, green: 0.118, blue: 0.196, alpha: 1)   // #3C1E32
    )
    /// Deep surface - dark buttons, prominent surfaces
    static let darkSurface = adaptiveColor(
        light: UIColor(red: 0.102, green: 0.067, blue: 0.086, alpha: 1),  // #1A1116
        dark:  UIColor(red: 0.157, green: 0.133, blue: 0.145, alpha: 1)   // #282225
    )

    // Backward-compat aliases used throughout existing views
    static var accent: Color { primaryDeep }
    static var accentSoft: Color { primarySoft }

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

    // MARK: - Comedogenic rating colors (0-5 scale)
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
        Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? dark : light })
    }
}

private extension Color {
    var uiColor: UIColor { UIColor(self) }
}

// MARK: - UIColor helpers for UIKit bridging
extension SkinTheme {
    static var accentUIColor: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: 0.910, green: 0.549, blue: 0.737, alpha: 1)
            : UIColor(red: 0.831, green: 0.412, blue: 0.604, alpha: 1)
        }
    }
    static var backgroundUIColor: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: 0.078, green: 0.063, blue: 0.071, alpha: 1)
            : UIColor(red: 0.992, green: 0.910, blue: 0.949, alpha: 1)
        }
    }
}

// MARK: - Legacy system font helper (existing call sites)
extension Font {
    static func skin(_ style: TextStyle, weight: Weight = .regular) -> Font {
        .system(style, design: .default, weight: weight)
    }
}

// MARK: - Cue typography scale (Barlow Condensed + SF Pro)
enum CueTextStyle {
    case display        // 56pt Bold - hero/splash headlines
    case heading1       // 44pt Bold - screen titles
    case heading2       // 34pt Bold - section headers
    case heading3       // 26pt Bold - card titles
    case bodyLarge      // 19pt Regular
    case body           // 17pt Regular
    case bodyBold       // 17pt Semibold
    case callout        // 16pt Regular
    case caption        // 14pt Regular
    case captionBold    // 14pt Medium
    case label          // 12pt Medium
}

extension Font {
    static func cue(_ style: CueTextStyle) -> Font {
        switch style {
        case .display:     return .system(size: 56, weight: .bold, design: .default)
        case .heading1:    return .system(size: 44, weight: .bold, design: .default)
        case .heading2:    return .system(size: 34, weight: .bold, design: .default)
        case .heading3:    return .system(size: 26, weight: .bold, design: .default)
        case .bodyLarge:   return .system(size: 19, weight: .regular)
        case .body:        return .system(size: 17, weight: .regular)
        case .bodyBold:    return .system(size: 17, weight: .semibold)
        case .callout:     return .system(size: 16, weight: .regular)
        case .caption:     return .system(size: 14, weight: .regular)
        case .captionBold: return .system(size: 14, weight: .medium)
        case .label:       return .system(size: 12, weight: .medium)
        }
    }
}
