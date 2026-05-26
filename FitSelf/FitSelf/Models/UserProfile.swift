import SwiftData
import Foundation

@Model
final class UserProfile {
    var nickname: String
    var gender: String
    var birthDate: Date
    var height: Double
    var activityLevel: String
    var fitnessGoal: String

    var targetWeight: Double
    var dailyCalorieGoal: Int
    var dailyExerciseGoal: Int
    var dailyWaterGoal: Int
    var macroRatioCarbs: Double
    var macroRatioProtein: Double
    var macroRatioFat: Double

    var unitWeight: String
    var unitHeight: String
    var unitDistance: String
    var unitEnergy: String
    var appearanceTheme: String
    var language: String

    var weightReminderEnabled: Bool
    var weightReminderHour: Int
    var weightReminderMinute: Int
    var exerciseReminderEnabled: Bool
    var exerciseReminderFrequency: String
    var waterReminderEnabled: Bool
    var waterReminderInterval: Int
    var weeklyReportEnabled: Bool

    var createdAt: Date
    var updatedAt: Date

    init(nickname: String = "",
         gender: String = "other",
         birthDate: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date(),
         height: Double = 170,
         activityLevel: String = "moderate",
         fitnessGoal: String = "maintain",
         targetWeight: Double = 65,
         dailyCalorieGoal: Int = 2000,
         dailyExerciseGoal: Int = 60,
         dailyWaterGoal: Int = 2000) {
        self.nickname = nickname
        self.gender = gender
        self.birthDate = birthDate
        self.height = height
        self.activityLevel = activityLevel
        self.fitnessGoal = fitnessGoal
        self.targetWeight = targetWeight
        self.dailyCalorieGoal = dailyCalorieGoal
        self.dailyExerciseGoal = dailyExerciseGoal
        self.dailyWaterGoal = dailyWaterGoal
        self.macroRatioCarbs = 0.45
        self.macroRatioProtein = 0.30
        self.macroRatioFat = 0.25
        self.unitWeight = "kg"
        self.unitHeight = "cm"
        self.unitDistance = "km"
        self.unitEnergy = "kcal"
        self.appearanceTheme = "system"
        self.language = "zh"
        self.weightReminderEnabled = true
        self.weightReminderHour = 8
        self.weightReminderMinute = 0
        self.exerciseReminderEnabled = false
        self.exerciseReminderFrequency = "mon_wed_fri"
        self.waterReminderEnabled = true
        self.waterReminderInterval = 120
        self.weeklyReportEnabled = true
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    static func bmr(gender: String, weight: Double, height: Double, age: Int) -> Double {
        let s = gender == "male" ? 5.0 : -161.0
        return 10.0 * weight + 6.25 * height - 5.0 * Double(age) + s
    }

    static func tdee(bmr: Double, activityLevel: String) -> Double {
        let multiplier: Double
        switch activityLevel {
        case "sedentary": multiplier = 1.2
        case "light": multiplier = 1.375
        case "moderate": multiplier = 1.55
        case "heavy": multiplier = 1.725
        default: multiplier = 1.55
        }
        return bmr * multiplier
    }
}