import SwiftUI

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = TodayViewModel()
    var onSettingsTap: (() -> Void)? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    greetingSection

                    TripleRingView(
                        calorieProgress: viewModel.calorieProgress,
                        exerciseProgress: viewModel.exerciseProgress,
                        waterProgress: viewModel.waterProgress,
                        calorieValue: viewModel.calorieValue,
                        exerciseValue: viewModel.exerciseValue,
                        waterValue: viewModel.waterValue,
                        calorieGoal: viewModel.calorieGoal,
                        exerciseGoal: viewModel.exerciseGoal,
                        waterGoal: viewModel.waterGoal
                    )

                    quickActions

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        StatCardView(
                            icon: "figure.walk",
                            title: "步数",
                            value: viewModel.steps.formatted(),
                            subtitle: "/ 10,000",
                            color: Color.chartCarbs
                        )

                        StatCardView(
                            icon: "flame",
                            title: "卡路里",
                            value: viewModel.calorieValue,
                            subtitle: "kcal",
                            color: Color.chartCalories
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(Color.appBackground)
            .navigationTitle("今日")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        onSettingsTap?()
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(Color.appMutedForeground)
                    }
                }
            }
        }
        .task {
            viewModel.configure(context: modelContext)
            await viewModel.loadData()
        }
        .refreshable {
            await viewModel.loadData()
        }
    }

    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Date().greetingText)
                .font(.appTitle2)
                .foregroundStyle(Color.appForeground)
            Text(Date().formattedDate)
                .font(.appSubhead)
                .foregroundStyle(Color.appMutedForeground)
        }
    }

    private var quickActions: some View {
        HStack(spacing: 12) {
            QuickActionButton(icon: "figure.run", title: "记录运动", color: Color.chartExercise) {}
            QuickActionButton(icon: "fork.knife", title: "记录饮食", color: Color.chartCalories) {}
            QuickActionButton(icon: "scalemass", title: "称体重", color: Color.chartWater) {}
        }
    }
}