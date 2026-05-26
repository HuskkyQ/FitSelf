import SwiftUI
import SwiftData

@Observable
final class TodayViewModel {
    var calorieProgress: Double = 0
    var exerciseProgress: Double = 0
    var waterProgress: Double = 0

    var calorieValue: String = "0"
    var exerciseValue: String = "0分钟"
    var waterValue: String = "0ml"

    var calorieGoal: String = "2,000 kcal"
    var exerciseGoal: String = "60分钟"
    var waterGoal: String = "2,000ml"

    var steps: Int = 0
    var suggestionText: String = ""

    private var workoutRepo: WorkoutRepository?
    private var nutritionRepo: NutritionRepository?
    private var waterRepo: WaterRepository?
    private var profileRepo: UserProfileRepository?

    func configure(context: ModelContext) {
        workoutRepo = WorkoutRepository(modelContext: context)
        nutritionRepo = NutritionRepository(modelContext: context)
        waterRepo = WaterRepository(modelContext: context)
        profileRepo = UserProfileRepository(modelContext: context)
    }

    func loadData() async {
        guard let workoutRepo, let nutritionRepo, let waterRepo, let profileRepo else { return }

        let today = Date()
        let profile: UserProfile
        do {
            profile = try profileRepo.ensureProfile()
        } catch {
            return
        }

        let nutrition = try? nutritionRepo.dailyNutritionSummary(for: today)
        let caloriesConsumed = nutrition?.calories ?? 0
        let calorieGoal = Double(profile.dailyCalorieGoal)

        let exerciseMinutes = (try? workoutRepo.totalExerciseDuration(in: today)) ?? 0
        let exerciseGoal = Double(profile.dailyExerciseGoal)

        let waterTotal = (try? waterRepo.totalWater(for: today)) ?? 0
        let waterGoal = Double(profile.dailyWaterGoal)

        await MainActor.run {
            self.calorieProgress = calorieGoal > 0 ? caloriesConsumed / calorieGoal : 0
            self.calorieValue = Int(caloriesConsumed).formatted()
            self.calorieGoal = profile.dailyCalorieGoal.formatted() + " kcal"

            self.exerciseProgress = exerciseGoal > 0 ? Double(exerciseMinutes) / exerciseGoal : 0
            self.exerciseValue = "\(exerciseMinutes)分钟"
            self.exerciseGoal = "\(profile.dailyExerciseGoal)分钟"

            self.waterProgress = waterGoal > 0 ? Double(waterTotal) / waterGoal : 0
            self.waterValue = "\(waterTotal)ml"
            self.waterGoal = "\(profile.dailyWaterGoal)ml"
        }
    }
}