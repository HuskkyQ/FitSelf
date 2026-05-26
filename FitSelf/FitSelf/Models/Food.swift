import SwiftData
import Foundation

@Model
final class Food {
    var name: String
    var nameEn: String?
    var brand: String?
    var barcode: String?
    var caloriesPer100g: Double
    var proteinPer100g: Double
    var fatPer100g: Double
    var carbsPer100g: Double
    var fiberPer100g: Double
    var sodiumPer100g: Double
    var sugarPer100g: Double
    var saturatedFatPer100g: Double
    var servingSize: Double?
    var servingDescription: String?
    var isCustom: Bool
    var isFavorite: Bool
    var category: String?
    var createdAt: Date

    init(name: String,
         caloriesPer100g: Double,
         proteinPer100g: Double = 0,
         fatPer100g: Double = 0,
         carbsPer100g: Double = 0,
         fiberPer100g: Double = 0,
         sodiumPer100g: Double = 0,
         sugarPer100g: Double = 0,
         saturatedFatPer100g: Double = 0,
         brand: String? = nil,
         barcode: String? = nil,
         nameEn: String? = nil,
         servingSize: Double? = nil,
         servingDescription: String? = nil,
         isCustom: Bool = false,
         category: String? = nil) {
        self.name = name
        self.caloriesPer100g = caloriesPer100g
        self.proteinPer100g = proteinPer100g
        self.fatPer100g = fatPer100g
        self.carbsPer100g = carbsPer100g
        self.fiberPer100g = fiberPer100g
        self.sodiumPer100g = sodiumPer100g
        self.sugarPer100g = sugarPer100g
        self.saturatedFatPer100g = saturatedFatPer100g
        self.brand = brand
        self.barcode = barcode
        self.nameEn = nameEn
        self.servingSize = servingSize
        self.servingDescription = servingDescription
        self.isCustom = isCustom
        self.isFavorite = false
        self.category = category
        self.createdAt = Date()
    }
}

@Model
final class FoodEntry {
    var food: Food?
    var customFoodName: String?
    var portionGrams: Double
    var meal: String
    var calories: Double
    var protein: Double
    var fat: Double
    var carbs: Double
    var fiber: Double
    var sodium: Double
    var sugar: Double
    var recordedAt: Date
    var createdAt: Date

    init(food: Food? = nil,
         customFoodName: String? = nil,
         portionGrams: Double,
         meal: String,
         calories: Double,
         protein: Double = 0,
         fat: Double = 0,
         carbs: Double = 0,
         fiber: Double = 0,
         sodium: Double = 0,
         sugar: Double = 0,
         recordedAt: Date = Date()) {
        self.food = food
        self.customFoodName = customFoodName
        self.portionGrams = portionGrams
        self.meal = meal
        self.calories = calories
        self.protein = protein
        self.fat = fat
        self.carbs = carbs
        self.fiber = fiber
        self.sodium = sodium
        self.sugar = sugar
        self.recordedAt = recordedAt
        self.createdAt = Date()
    }
}