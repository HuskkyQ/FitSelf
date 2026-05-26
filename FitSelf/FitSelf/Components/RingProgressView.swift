import SwiftUI

struct RingProgressView: View {
    let progress: Double
    let color: Color
    let label: String
    let value: String
    let goal: String
    let lineWidth: CGFloat

    init(progress: Double, color: Color, label: String, value: String, goal: String, lineWidth: CGFloat = 12) {
        self.progress = progress
        self.color = color
        self.label = label
        self.value = value
        self.goal = goal
        self.lineWidth = lineWidth
    }

    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                Circle()
                    .stroke(Color.appMuted.opacity(0.2), lineWidth: lineWidth)

                Circle()
                    .trim(from: 0, to: min(progress, 1.0))
                    .stroke(
                        progress >= 1.0 ? Color.appAccent : color,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.6), value: progress)

                VStack(spacing: 2) {
                    Text(value)
                        .font(.appTitle3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.appForeground)
                    Text(label)
                        .font(.appCaption)
                        .foregroundStyle(Color.appMutedForeground)
                }
            }

            Text(goal)
                .font(.appCaption)
                .foregroundStyle(Color.appMutedForeground)
        }
        .accessibilityLabel("\(label): \(value), 目标 \(goal)")
        .accessibilityValue("已完成 \(Int(progress * 100))%")
    }
}

struct TripleRingView: View {
    let calorieProgress: Double
    let exerciseProgress: Double
    let waterProgress: Double

    let calorieValue: String
    let exerciseValue: String
    let waterValue: String

    let calorieGoal: String
    let exerciseGoal: String
    let waterGoal: String

    var body: some View {
        HStack(spacing: 24) {
            RingProgressView(
                progress: calorieProgress,
                color: Color.chartCalories,
                label: "卡路里",
                value: calorieValue,
                goal: calorieGoal
            )

            RingProgressView(
                progress: exerciseProgress,
                color: Color.chartExercise,
                label: "运动",
                value: exerciseValue,
                goal: exerciseGoal
            )

            RingProgressView(
                progress: waterProgress,
                color: Color.chartWater,
                label: "饮水",
                value: waterValue,
                goal: waterGoal
            )
        }
    }
}