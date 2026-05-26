import SwiftUI

struct StatCardView: View {
    let icon: String
    let title: String
    let value: String
    var subtitle: String? = nil
    var color: Color? = nil
    var trend: Trend? = nil

    enum Trend {
        case up(Double)
        case down(Double)
        case same
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color ?? Color.appPrimary)
                    .font(.title3)
                Spacer()
                if let trend {
                    trendView(trend)
                }
            }

            Text(value)
                .font(.appHero)
                .foregroundStyle(Color.appForeground)

            Text(title)
                .font(.appFootnote)
                .foregroundStyle(Color.appMutedForeground)

            if let subtitle {
                Text(subtitle)
                    .font(.appCaption)
                    .foregroundStyle(Color.appMutedForeground)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func trendView(_ trend: Trend) -> some View {
        switch trend {
        case .up(let value):
            Label(String(format: "+%.1f", value), systemImage: "arrow.up.right")
                .font(.appCaption)
                .foregroundStyle(Color.appAccent)
        case .down(let value):
            Label(String(format: "-%.1f", value), systemImage: "arrow.down.right")
                .font(.appCaption)
                .foregroundStyle(Color.appDestructive)
        case .same:
            Text("—")
                .font(.appCaption)
                .foregroundStyle(Color.appMutedForeground)
        }
    }
}