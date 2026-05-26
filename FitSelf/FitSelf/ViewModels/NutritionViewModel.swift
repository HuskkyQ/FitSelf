import SwiftData
import Foundation

@Observable
final class NutritionViewModel {
    var dailyCalories: Double = 0
    var dailyProtein: Double = 0
    var dailyFat: Double = 0
    var dailyCarbs: Double = 0
    var dailyFiber: Double = 0
    var dailySodium: Double = 0
    var dailySugar: Double = 0

    var calorieGoal: Int = 2000
    var proteinGoal: Double = 150
    var fatGoal: Double = 67
    var carbsGoal: Double = 225

    var breakfastEntries: [FoodEntry] = []
    var lunchEntries: [FoodEntry] = []
    var dinnerEntries: [FoodEntry] = []
    var snackEntries: [FoodEntry] = []

    var dailyWaterMl: Int = 0
    var waterGoal: Int = 2000
    var waterEntries: [WaterEntry] = []
    var waterProgress: Double { waterGoal > 0 ? Double(dailyWaterMl) / Double(waterGoal) : 0 }

    var calorieProgress: Double { calorieGoal > 0 ? dailyCalories / Double(calorieGoal) : 0 }
    var proteinProgress: Double { proteinGoal > 0 ? dailyProtein / proteinGoal : 0 }
    var fatProgress: Double { fatGoal > 0 ? dailyFat / fatGoal : 0 }
    var carbsProgress: Double { carbsGoal > 0 ? dailyCarbs / carbsGoal : 0 }

    var remainingCalories: Int { max(0, calorieGoal - Int(dailyCalories)) }

    private var nutritionRepo: NutritionRepository?
    private var waterRepo: WaterRepository?
    private var profileRepo: UserProfileRepository?

    func configure(context: ModelContext) {
        nutritionRepo = NutritionRepository(modelContext: context)
        waterRepo = WaterRepository(modelContext: context)
        profileRepo = UserProfileRepository(modelContext: context)
    }

    func loadData() async {
        guard let nutritionRepo, let profileRepo, let waterRepo else { return }

        let today = Date()
        let profile: UserProfile
        do {
            profile = try profileRepo.ensureProfile()
        } catch {
            return
        }

        do {
            let summary = try nutritionRepo.dailyNutritionSummary(for: today)
            await MainActor.run {
                self.dailyCalories = summary.calories
                self.dailyProtein = summary.protein
                self.dailyFat = summary.fat
                self.dailyCarbs = summary.carbs
                self.dailyFiber = summary.fiber
                self.dailySodium = summary.sodium
                self.dailySugar = summary.sugar

                self.calorieGoal = profile.dailyCalorieGoal
                self.proteinGoal = Double(profile.dailyCalorieGoal) * profile.macroRatioProtein / 4.0
                self.fatGoal = Double(profile.dailyCalorieGoal) * profile.macroRatioFat / 9.0
                self.carbsGoal = Double(profile.dailyCalorieGoal) * profile.macroRatioCarbs / 4.0

                self.waterGoal = profile.dailyWaterGoal
            }
        } catch {
            // 保持默认值
        }

        do {
            let entries = try nutritionRepo.entries(for: today)
            await MainActor.run {
                self.breakfastEntries = entries.filter { $0.meal == "breakfast" }
                self.lunchEntries = entries.filter { $0.meal == "lunch" }
                self.dinnerEntries = entries.filter { $0.meal == "dinner" }
                self.snackEntries = entries.filter { $0.meal == "snack" }
            }
        } catch {
            // 空列表
        }

        do {
            let waterList = try waterRepo.waterEntries(for: today)
            let total = waterList.reduce(0) { $0 + $1.milliliters }
            await MainActor.run {
                self.waterEntries = waterList
                self.dailyWaterMl = total
            }
        } catch {
            // 空数据
        }
    }

    func addEntry(food: Food, portionGrams: Double, meal: String) {
        guard let repo = nutritionRepo else { return }
        let entry = repo.addEntry(food: food, portionGrams: portionGrams, meal: meal)
        appendEntry(entry, to: meal)
    }

    func addEntry(food: Food? = nil, portionGrams: Double, meal: String, calories: Double, protein: Double = 0, fat: Double = 0, carbs: Double = 0) {
        guard let repo = nutritionRepo else { return }
        let entry = repo.addCustomEntry(
            name: food?.name ?? "自定义食物",
            portionGrams: portionGrams,
            meal: meal,
            calories: calories,
            protein: protein,
            fat: fat,
            carbs: carbs
        )
        appendEntry(entry, to: meal)
    }

    func deleteEntry(_ entry: FoodEntry) {
        guard let repo = nutritionRepo else { return }
        removeEntry(entry, from: entry.meal)
        repo.delete(entry)
        recalculateTotals()
    }

    func addWater(ml: Int) {
        guard let repo = waterRepo else { return }
        let entry = repo.addWater(milliliters: ml)
        waterEntries.append(entry)
        dailyWaterMl += ml
    }

    func deleteWater(_ entry: WaterEntry) {
        guard let repo = waterRepo else { return }
        dailyWaterMl -= entry.milliliters
        waterEntries.removeAll { $0.id == entry.id }
        try? repo.deleteEntry(entry)
    }

    private func appendEntry(_ entry: FoodEntry, to meal: String) {
        switch meal {
        case "breakfast": breakfastEntries.append(entry)
        case "lunch": lunchEntries.append(entry)
        case "dinner": dinnerEntries.append(entry)
        case "snack": snackEntries.append(entry)
        default: snackEntries.append(entry)
        }
        recalculateTotals()
    }

    private func removeEntry(_ entry: FoodEntry, from meal: String) {
        switch meal {
        case "breakfast": breakfastEntries.removeAll { $0.id == entry.id }
        case "lunch": lunchEntries.removeAll { $0.id == entry.id }
        case "dinner": dinnerEntries.removeAll { $0.id == entry.id }
        case "snack": snackEntries.removeAll { $0.id == entry.id }
        default: snackEntries.removeAll { $0.id == entry.id }
        }
        recalculateTotals()
    }

    private func recalculateTotals() {
        let all = breakfastEntries + lunchEntries + dinnerEntries + snackEntries
        dailyCalories = all.reduce(0) { $0 + $1.calories }
        dailyProtein = all.reduce(0) { $0 + $1.protein }
        dailyFat = all.reduce(0) { $0 + $1.fat }
        dailyCarbs = all.reduce(0) { $0 + $1.carbs }
        dailyFiber = all.reduce(0) { $0 + $1.fiber }
        dailySodium = all.reduce(0) { $0 + $1.sodium }
        dailySugar = all.reduce(0) { $0 + $1.sugar }
    }
}