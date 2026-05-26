import SwiftUI

extension Color {
    // MARK: - 自适应明暗主题颜色

    static let appPrimary = Color(hex: "F97316")
    static let appOnPrimary = Color.white
    static let appSecondary = Color(hex: "FB923C")
    static let appAccent = Color(hex: "22C55E")
    static let appOnAccent = Color.white

    static let appBackground = Color(
        light: Color(hex: "F5F5F5"),
        dark: Color(hex: "0A0A0A")
    )
    static let appForeground = Color(
        light: Color(hex: "171717"),
        dark: Color(hex: "FAFAFA")
    )
    static let appCard = Color(
        light: Color.white,
        dark: Color(hex: "1A1A1A")
    )
    static let appCardForeground = Color(
        light: Color(hex: "171717"),
        dark: Color(hex: "FAFAFA")
    )
    static let appMuted = Color(
        light: Color(hex: "D4D4D4"),
        dark: Color(hex: "404040")
    )
    static let appMutedForeground = Color(
        light: Color(hex: "737373"),
        dark: Color(hex: "A3A3A3")
    )
    static let appBorder = Color(
        light: Color(hex: "E5E5E5"),
        dark: Color(hex: "2A2A2A")
    )
    static let appDestructive = Color(hex: "EF4444")
    static let appOnDestructive = Color.white
    static let appRing = Color(
        light: Color(hex: "E5E5E5"),
        dark: Color(hex: "3A3A3A")
    )

    static let appSuccess = Color(hex: "22C55E")
    static let appWarning = Color(hex: "F59E0B")
    static let appError = Color(hex: "EF4444")
    static let appInfo = Color(hex: "3B82F6")

    static let chartCalories = Color(hex: "F97316")
    static let chartExercise = Color(hex: "22C55E")
    static let chartWater = Color(hex: "3B82F6")
    static let chartCarbs = Color(hex: "F59E0B")
    static let chartFat = Color(hex: "EC4899")
    static let chartProtein = Color(hex: "8B5CF6")

    // MARK: - 自适应初始化

    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}