import SwiftUI

struct WorkoutIconView: View {
    let iconName: String
    let fallback: String
    let size: CGFloat
    let color: Color

    init(iconName: String, fallback: String = "figure.run", size: CGFloat = 20, color: Color = Color.appPrimary) {
        self.iconName = iconName
        self.fallback = fallback
        self.size = size
        self.color = color
    }

    var body: some View {
        Image(systemName: iconExists ? iconName : fallback)
            .font(.system(size: size))
            .foregroundStyle(color)
    }

    private var iconExists: Bool {
        UIImage(systemName: iconName) != nil
    }
}