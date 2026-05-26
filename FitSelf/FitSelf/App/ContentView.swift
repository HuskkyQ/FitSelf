import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [
            UserProfile.self, Workout.self, WorkoutExercise.self, WorkoutSet.self,
            Food.self, FoodEntry.self, BodyMeasurement.self, WaterEntry.self
        ], inMemory: true)
}