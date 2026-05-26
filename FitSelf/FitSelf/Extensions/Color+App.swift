import SwiftUI

extension Color {
    static let appPrimary = Color(hex: "F97316")
    static let appOnPrimary = Color.white
    static let appSecondary = Color(hex: "FB923C")
    static let appAccent = Color(hex: "22C55E")
    static let appOnAccent = Color.white
    static let appBackground = Color(hex: "0A0A0A")
    static let appForeground = Color(hex: "FAFAFA")
    static let appCard = Color(hex: "1A1A1A")
    static let appCardForeground = Color(hex: "FAFAFA")
    static let appMuted = Color(hex: "404040")
    static let appMutedForeground = Color(hex: "737373")
    static let appBorder = Color(hex: "2A2A2A")
    static let appDestructive = Color(hex: "EF4444")
    static let appOnDestructive = Color.white
    static let appRing = Color(hex: "3A3A3A")

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