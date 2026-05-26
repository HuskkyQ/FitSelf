import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("今日", systemImage: "house.fill")
                }

            WorkoutView()
                .tabItem {
                    Label("运动", systemImage: "figure.run")
                }

            NutritionView()
                .tabItem {
                    Label("饮食", systemImage: "fork.knife")
                }

            TrendsView()
                .tabItem {
                    Label("趋势", systemImage: "chart.line.uptrend.xyaxis")
                }

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
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