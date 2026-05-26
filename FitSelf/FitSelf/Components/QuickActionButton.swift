import SwiftUI

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)

                Text(title)
                    .font(.appFootnote)
                    .foregroundStyle(Color.appForeground)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .sensoryFeedback(.impact(weight: .light, intensity: 0.5), trigger: true)
    }
}