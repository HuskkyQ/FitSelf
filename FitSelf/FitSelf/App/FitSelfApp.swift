import SwiftUI
import SwiftData

@main
struct FitSelfApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            UserProfile.self,
            Workout.self,
            WorkoutExercise.self,
            WorkoutSet.self,
            Food.self,
            FoodEntry.self,
            BodyMeasurement.self,
            WaterEntry.self
        ]) { result in
            if case .success(let container) = result {
                let context = container.mainContext
                FoodDatabaseSeeder.seed(context: context)
            }
        }
    }
}