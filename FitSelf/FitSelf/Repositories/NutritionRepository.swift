import SwiftData
import Foundation

struct DailyNutritionSummary {
    var calories: Double
    var protein: Double
    var fat: Double
    var carbs: Double
    var fiber: Double
    var sodium: Double
    var sugar: Double
}

final class NutritionRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addEntry(food: Food, portionGrams: Double, meal: String) -> FoodEntry {
        let ratio = portionGrams / 100.0
        let entry = FoodEntry(
            food: food,
            portionGrams: portionGrams,
            meal: meal,
            calories: food.caloriesPer100g * ratio,
            protein: food.proteinPer100g * ratio,
            fat: food.fatPer100g * ratio,
            carbs: food.carbsPer100g * ratio,
            fiber: food.fiberPer100g * ratio,
            sodium: food.sodiumPer100g * ratio,
            sugar: food.sugarPer100g * ratio
        )
        modelContext.insert(entry)
        return entry
    }

    func addCustomEntry(name: String, portionGrams: Double, meal: String, calories: Double, protein: Double = 0, fat: Double = 0, carbs: Double = 0) -> FoodEntry {
        let entry = FoodEntry(
            customFoodName: name,
            portionGrams: portionGrams,
            meal: meal,
            calories: calories,
            protein: protein,
            fat: fat,
            carbs: carbs
        )
        modelContext.insert(entry)
        return entry
    }

    func entries(for date: Date) throws -> [FoodEntry] {
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        let descriptor = FetchDescriptor<FoodEntry>(
            predicate: #Predicate<FoodEntry> {
                $0.recordedAt >= start && $0.recordedAt < end
            }
        )
        return try modelContext.fetch(descriptor)
    }

    func dailyNutritionSummary(for date: Date) throws -> DailyNutritionSummary {
        let entries = try self.entries(for: date)
        return DailyNutritionSummary(
            calories: entries.reduce(0) { $0 + $1.calories },
            protein: entries.reduce(0) { $0 + $1.protein },
            fat: entries.reduce(0) { $0 + $1.fat },
            carbs: entries.reduce(0) { $0 + $1.carbs },
            fiber: entries.reduce(0) { $0 + $1.fiber },
            sodium: entries.reduce(0) { $0 + $1.sodium },
            sugar: entries.reduce(0) { $0 + $1.sugar }
        )
    }

    func searchFood(query: String, limit: Int = 20) throws -> [Food] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return [] }
        var descriptor = FetchDescriptor<Food>(
            predicate: #Predicate<Food> {
                $0.name.contains(trimmed)
            }
        )
        descriptor.fetchLimit = limit
        return try modelContext.fetch(descriptor)
    }

    func toggleFavorite(_ food: Food) throws {
        food.isFavorite.toggle()
        try modelContext.save()
    }

    func delete(_ entry: FoodEntry) {
        modelContext.delete(entry)
        try? modelContext.save()
    }
}