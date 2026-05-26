import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .today

    enum Tab: Int, CaseIterable {
        case today = 0
        case workout = 1
        case nutrition = 2
        case trends = 3
        case settings = 4
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView(onSettingsTap: { selectedTab = .settings })
                .tabItem {
                    Label("今日", systemImage: "house.fill")
                }
                .tag(Tab.today)

            WorkoutView()
                .tabItem {
                    Label("运动", systemImage: "figure.run")
                }
                .tag(Tab.workout)

            NutritionView()
                .tabItem {
                    Label("饮食", systemImage: "fork.knife")
                }
                .tag(Tab.nutrition)

            TrendsView()
                .tabItem {
                    Label("趋势", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(Tab.trends)

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
                .tag(Tab.settings)
        }
        .tint(Color.appPrimary)
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [
            UserProfile.self, Workout.self, WorkoutExercise.self, WorkoutSet.self,
            Food.self, FoodEntry.self, BodyMeasurement.self, WaterEntry.self
        ], inMemory: true)
}