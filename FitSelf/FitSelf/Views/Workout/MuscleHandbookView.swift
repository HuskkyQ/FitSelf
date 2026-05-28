import SwiftUI

struct MuscleHandbookView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMuscle: MuscleGroupData?
    @State private var selectedTab = 0

    private let sections = MuscleGroupStore.groupedBySection

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    PPLOverview()

                    LazyVStack(spacing: 16) {
ForEach(sections, id: \.section) { section in
                    MuscleSectionCard(
                        title: section.title,
                        iconType: section.iconType,
                        colorHex: section.color,
                        muscles: section.muscles,
                        onSelect: { muscle in selectedMuscle = muscle }
                    )
                        }
                    }
                    .padding(.horizontal, 16)

                    WeakPointsCard()
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                }
                .padding(.top, 8)
            }
            .background(Color.appBackground)
            .navigationTitle("肌群手册")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
            .sheet(item: $selectedMuscle) { muscle in
                MuscleDetailView(muscle: muscle)
            }
        }
    }
}

// MARK: - PPL 概览

private struct PPLOverview: View {
    var body: some View {
        HStack(spacing: 12) {
            PPLBadge(label: "推 Push", iconType: .sfSymbol("dumbbell.fill"), color: Color(hex: "F97316"))
            PPLBadge(label: "拉 Pull", iconType: .sfSymbol("figure.climbing"), color: Color(hex: "8B5CF6"))
            PPLBadge(label: "腿 Legs", iconType: .sfSymbol("figure.strengthtraining.functional"), color: Color(hex: "22C55E"))
            PPLBadge(label: "核心 Core", iconType: .abs, color: Color(hex: "3B82F6"))
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }
}

private struct PPLBadge: View {
    let label: String
    let iconType: IconType
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay(
                    SectionIconView(iconType: iconType, size: 20, color: color)
                )

            Text(label)
                .font(.appCaption2)
                .foregroundStyle(Color.appMutedForeground)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - 通用分区图标

private struct SectionIconView: View {
    let iconType: IconType
    let size: CGFloat
    let color: Color

    var body: some View {
        switch iconType {
        case .sfSymbol(let name):
            WorkoutIconView(iconName: name, fallback: "figure.run", size: size, color: color)
        case .abs:
            AbsIconView(size: size, color: color)
        }
    }
}

// MARK: - 腹肌图标（六块腹肌）

private struct AbsIconView: View {
    let size: CGFloat
    let color: Color

    var body: some View {
        let blockW = size * 0.32
        let blockH = size * 0.22
        let spacing = size * 0.06
        let totalW = blockW * 2 + spacing
        let totalH = blockH * 3 + spacing * 2

        VStack(spacing: spacing) {
            HStack(spacing: spacing) {
                roundedBlock(blockW, blockH)
                roundedBlock(blockW, blockH)
            }
            HStack(spacing: spacing) {
                roundedBlock(blockW, blockH)
                roundedBlock(blockW, blockH)
            }
            HStack(spacing: spacing) {
                roundedBlock(blockW, blockH)
                roundedBlock(blockW, blockH)
            }
        }
    }

    private func roundedBlock(_ w: CGFloat, _ h: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: w, height: h)
    }
}

// MARK: - 肌群分区卡片

private struct MuscleSectionCard: View {
    let title: String
    let iconType: IconType
    let colorHex: String
    let muscles: [MuscleGroupData]
    let onSelect: (MuscleGroupData) -> Void

    private var accentColor: Color { Color(hex: colorHex) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Circle()
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                    .overlay(
                        SectionIconView(iconType: iconType, size: 16, color: accentColor)
                    )

                Text(title)
                    .font(.appTitle3)
                    .foregroundStyle(Color.appForeground)

                Spacer()

                Text("\(muscles.count) 个肌群")
                    .font(.appCaption)
                    .foregroundStyle(Color.appMutedForeground)
            }

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                ForEach(muscles) { muscle in
                    MuscleChip(muscle: muscle, color: accentColor, onTap: { onSelect(muscle) })
                }
            }
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - 肌群标签

private struct MuscleChip: View {
    let muscle: MuscleGroupData
    let color: Color
    let onTap: () -> Void

    private var chipIcon: String {
        muscle.icon ?? muscle.nameEn.prefix(2).lowercased()
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Group {
                            if let icon = muscle.icon {
                                WorkoutIconView(iconName: icon, fallback: "figure.run", size: 12, color: color)
                            } else {
                                Text(muscle.abbr ?? String(muscle.nameEn.prefix(2)))
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(color)
                            }
                        }
                    )

                VStack(alignment: .leading, spacing: 1) {
                    Text(muscle.name)
                        .font(.appCaption)
                        .foregroundStyle(Color.appForeground)
                        .lineLimit(1)

                    if !muscle.primaryActions.isEmpty {
                        Text(muscle.primaryActions.prefix(2).joined(separator: " · "))
                            .font(.system(size: 9))
                            .foregroundStyle(Color.appMutedForeground)
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(color.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

// MARK: - 薄弱肌群卡片

private struct WeakPointsCard: View {
    private let items = MuscleGroupStore.weakPoints

    private let icons: [String: String] = [
        "三角肌后束": "figure.strengthtraining.functional",
        "中下斜方肌": "figure.climbing",
        "腘绳肌": "figure.strengthtraining.traditional",
        "臀中肌": "figure.strengthtraining.functional",
        "腹横肌": "figure.strengthtraining.functional",
        "肩袖稳定肌群": "figure.strengthtraining.functional",
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.appWarning)

                Text("新手必记薄弱肌群")
                    .font(.appTitle3)
                    .foregroundStyle(Color.appForeground)

                Spacer()

                Text("最易失衡")
                    .font(.appCaption2)
                    .foregroundStyle(Color.appWarning)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.appWarning.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(spacing: 6) {
                        Image(systemName: icons[item] ?? "figure.strengthtraining.functional")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.appWarning)

                        Text(item)
                            .font(.appCaption)
                            .foregroundStyle(Color.appForeground)
                            .lineLimit(1)

                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.appWarning.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - 肌群详情

struct MuscleDetailView: View {
    let muscle: MuscleGroupData
    @Environment(\.dismiss) private var dismiss

    private let pplColors: [String: String] = [
        "push": "F97316",
        "pull": "8B5CF6",
        "legs": "22C55E",
        "core": "3B82F6",
    ]

    private var accentColor: Color {
        Color(hex: pplColors[muscle.ppl] ?? "F97316")
    }

    private var pplLabel: String {
        switch muscle.ppl {
        case "push": return "推 Push"
        case "pull": return "拉 Pull"
        case "legs": return "腿 Legs"
        case "core": return "核心 Core"
        default: return muscle.ppl
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    muscleHeader
                    muscleInfoSection
                    if let subs = muscle.subdivisions, !subs.isEmpty {
                        subdivisionsSection(subs)
                    }
                    actionsSection
                }
                .padding(16)
                .padding(.bottom, 32)
            }
            .background(Color.appBackground)
            .navigationTitle(muscle.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }

    private var muscleHeader: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(accentColor.opacity(0.15))
                .frame(width: 64, height: 64)
                .overlay(
                    Group {
                        if let icon = muscle.icon {
                            WorkoutIconView(iconName: icon, fallback: "figure.run", size: 28, color: accentColor)
                        } else {
                            Text(muscle.abbr ?? String(muscle.nameEn.prefix(3)))
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(accentColor)
                        }
                    }
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(muscle.name)
                    .font(.appTitle2)
                    .foregroundStyle(Color.appForeground)

                Text(muscle.nameEn)
                    .font(.appCallout)
                    .foregroundStyle(Color.appMutedForeground)

                HStack(spacing: 6) {
                    Text(pplLabel)
                        .font(.appCaption2)
                        .foregroundStyle(accentColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(accentColor.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                    if let note = muscle.note {
                        Text(note)
                            .font(.appCaption2)
                            .foregroundStyle(Color.appWarning)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.appWarning.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }

                    if muscle.weakPoint == true {
                        Text("薄弱")
                            .font(.appCaption2)
                            .foregroundStyle(Color.appError)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.appError.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }

            Spacer()
        }
    }

    private var muscleInfoSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let location = muscle.location {
                InfoRow(icon: "mappin.and.ellipse", title: "位置", value: location)
            }

            if let functions = muscle.functions, !functions.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(accentColor)
                        Text("核心功能")
                            .font(.appSubhead)
                            .foregroundStyle(Color.appMutedForeground)
                    }

                    FlowLayout(spacing: 6) {
ForEach(functions, id: \.self) { functionItem in
                        Text(functionItem)
                                .font(.appCaption)
                                .foregroundStyle(Color.appForeground)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(accentColor.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }

            if let desc = muscle.description {
                InfoRow(icon: "info.circle", title: "说明", value: desc)
            }
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func subdivisionsSection(_ subs: [MuscleSubdivision]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 12))
                    .foregroundStyle(accentColor)
                Text("肌群细分")
                    .font(.appSubhead)
                    .foregroundStyle(Color.appMutedForeground)
            }

            ForEach(subs, id: \.name) { sub in
                SubdivisionRow(sub: sub, color: accentColor)
            }
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(accentColor)
                Text("训练动作")
                    .font(.appSubhead)
                    .foregroundStyle(Color.appMutedForeground)
            }

            ForEach(muscle.primaryActions, id: \.self) { action in
                HStack(spacing: 10) {
                    Circle()
                        .fill(accentColor.opacity(0.2))
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: actionIcon(for: action))
                                .font(.system(size: 12))
                                .foregroundStyle(accentColor)
                        )

                    Text(action)
                        .font(.appCallout)
                        .foregroundStyle(Color.appForeground)

                    Spacer()
                }
                .padding(.vertical, 6)
            }
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func actionIcon(for action: String) -> String {
        if action.contains("蹲") { return "figure.strengthtraining.traditional" }
        if action.contains("推") { return "dumbbell.fill" }
        if action.contains("划船") || action.contains("拉") { return "figure.rowing" }
        if action.contains("弯举") { return "dumbbell" }
        if action.contains("飞鸟") { return "dumbbell" }
        if action.contains("举") { return "dumbbell" }
        if action.contains("引体") || action.contains("臂屈伸") { return "figure.climbing" }
        if action.contains("仰卧") { return "figure.strengthtraining.functional" }
        if action.contains("硬拉") { return "figure.strengthtraining.traditional" }
        if action.contains("支撑") { return "figure.strengthtraining.functional" }
        if action.contains("卷腹") { return "figure.strengthtraining.functional" }
        return "figure.strengthtraining.traditional"
    }
}

private struct SubdivisionRow: View {
    let sub: MuscleSubdivision
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Circle()
                    .fill(color.opacity(0.25))
                    .frame(width: 8, height: 8)

                Text(sub.name)
                    .font(.appCallout)
                    .foregroundStyle(Color.appForeground)

                if let note = sub.note {
                    Text(note)
                        .font(.system(size: 10))
                        .foregroundStyle(color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(color.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }

                if sub.weakPoint == true {
                    Text("薄弱")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.appError)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.appError.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }

                Spacer()
            }

            if let functions = sub.functions, !functions.isEmpty {
                Text(functions.joined(separator: " · "))
                    .font(.appCaption)
                    .foregroundStyle(Color.appMutedForeground)
            }

            if let actions = sub.actions, !actions.isEmpty {
                FlowLayout(spacing: 4) {
                    ForEach(actions, id: \.self) { action in
                        Text(action)
                            .font(.system(size: 11))
                            .foregroundStyle(color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(color.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(color.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(Color.appMutedForeground)
                .frame(width: 18, alignment: .center)
                .padding(.top, 1)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.appCaption)
                    .foregroundStyle(Color.appMutedForeground)
                Text(value)
                    .font(.appCallout)
                    .foregroundStyle(Color.appForeground)
            }
        }
    }
}

// MARK: - 流式布局

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: ProposedViewSize(width: bounds.width, height: nil), subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        let totalHeight = y + rowHeight
        return (CGSize(width: maxWidth, height: totalHeight), positions)
    }
}
