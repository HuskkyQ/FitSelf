import SwiftData
import Foundation

@Observable
final class OnboardingViewModel {
    let totalSteps = 5

    var currentStep: Int = 0

    var gender: String = "other"
    var birthDate: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    var height: Double = 170

    var weight: Double = 65
    var bodyFatPercentage: Double? = nil

    var fitnessGoal: String = "maintain"
    var activityLevel: String = "moderate"

    var dailyCalorieGoal: Int = 2000
    var dailyExerciseGoal: Int = 60
    var dailyWaterGoal: Int = 2000

    func calculateRecommendedCalories() -> Int {
        let ageComponents = Calendar.current.dateComponents([.year], from: birthDate, to: Date())
        let age = ageComponents.year ?? 25
        let bmr = UserProfile.bmr(gender: gender, weight: weight, height: height, age: age)
        let tdee = UserProfile.tdee(bmr: bmr, activityLevel: activityLevel)

        switch fitnessGoal {
        case "lose": return Int(tdee * 0.8)
        case "gain": return Int(tdee * 1.15)
        default: return Int(tdee)
        }
    }

    func calculateRecommendedExercise() -> Int {
        switch activityLevel {
        case "sedentary": return 30
        case "light": return 45
        case "moderate": return 60
        case "heavy": return 75
        default: return 60
        }
    }

    func calculateRecommendedWater() -> Int {
        Int(weight * 30 / 1000 * 1000)
    }

    func updateRecommendations() {
        dailyCalorieGoal = calculateRecommendedCalories()
        dailyExerciseGoal = calculateRecommendedExercise()
        dailyWaterGoal = calculateRecommendedWater()
    }

    func saveProfile(context: ModelContext) throws {
        let descriptor = FetchDescriptor<UserProfile>()
        let existing = try context.fetch(descriptor).first

        let profile = existing ?? UserProfile()
        profile.gender = gender
        profile.birthDate = birthDate
        profile.height = height
        profile.fitnessGoal = fitnessGoal
        profile.activityLevel = activityLevel
        profile.dailyCalorieGoal = dailyCalorieGoal
        profile.dailyExerciseGoal = dailyExerciseGoal
        profile.dailyWaterGoal = dailyWaterGoal
        profile.targetWeight = weight

        if profile.nickname.isEmpty {
            profile.nickname = "FitSelf 用户"
        }

        if existing == nil {
            context.insert(profile)
        }

        let measurement = BodyMeasurement(
            weight: weight,
            bodyFatPercentage: bodyFatPercentage
        )
        context.insert(measurement)

        try context.save()
    }
}