import SwiftData
import Foundation

@Observable
final class SettingsViewModel {
    var profile: UserProfile?

    var nickname: String = ""
    var gender: String = "other"
    var birthDate: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    var height: Double = 170
    var activityLevel: String = "moderate"
    var fitnessGoal: String = "maintain"
    var targetWeight: Double = 65

    var dailyCalorieGoal: Int = 2000
    var dailyExerciseGoal: Int = 60
    var dailyWaterGoal: Int = 2000
    var macroRatioCarbs: Double = 0.45
    var macroRatioProtein: Double = 0.30
    var macroRatioFat: Double = 0.25

    var unitWeight: String = "kg"
    var unitHeight: String = "cm"
    var appearanceTheme: String = "system"

    var weightReminderEnabled: Bool = true
    var exerciseReminderEnabled: Bool = false
    var waterReminderEnabled: Bool = true
    var weeklyReportEnabled: Bool = true

    private var profileRepo: UserProfileRepository?

    func configure(context: ModelContext, appearanceTheme: String = "system") {
        profileRepo = UserProfileRepository(modelContext: context)
        loadProfile(appearanceTheme: appearanceTheme)
    }

    func loadProfile(appearanceTheme: String = "system") {
        guard let repo = profileRepo else { return }
        do {
            let p = try repo.ensureProfile()
            profile = p
            nickname = p.nickname
            gender = p.gender
            birthDate = p.birthDate
            height = p.height
            activityLevel = p.activityLevel
            fitnessGoal = p.fitnessGoal
            targetWeight = p.targetWeight
            dailyCalorieGoal = p.dailyCalorieGoal
            dailyExerciseGoal = p.dailyExerciseGoal
            dailyWaterGoal = p.dailyWaterGoal
            macroRatioCarbs = p.macroRatioCarbs
            macroRatioProtein = p.macroRatioProtein
            macroRatioFat = p.macroRatioFat
            unitWeight = p.unitWeight
            unitHeight = p.unitHeight
            self.appearanceTheme = appearanceTheme
            weightReminderEnabled = p.weightReminderEnabled
            exerciseReminderEnabled = p.exerciseReminderEnabled
            waterReminderEnabled = p.waterReminderEnabled
            weeklyReportEnabled = p.weeklyReportEnabled
        } catch {
            // 使用默认值
        }
    }

    func saveProfile() throws {
        guard let repo = profileRepo else { return }
        _ = try repo.updateProfile { profile in
            profile.nickname = self.nickname
            profile.gender = self.gender
            profile.birthDate = self.birthDate
            profile.height = self.height
            profile.activityLevel = self.activityLevel
            profile.fitnessGoal = self.fitnessGoal
            profile.targetWeight = self.targetWeight
            profile.dailyCalorieGoal = self.dailyCalorieGoal
            profile.dailyExerciseGoal = self.dailyExerciseGoal
            profile.dailyWaterGoal = self.dailyWaterGoal
            profile.macroRatioCarbs = self.macroRatioCarbs
            profile.macroRatioProtein = self.macroRatioProtein
            profile.macroRatioFat = self.macroRatioFat
            profile.unitWeight = self.unitWeight
            profile.unitHeight = self.unitHeight
            profile.appearanceTheme = self.appearanceTheme
            profile.weightReminderEnabled = self.weightReminderEnabled
            profile.exerciseReminderEnabled = self.exerciseReminderEnabled
            profile.waterReminderEnabled = self.waterReminderEnabled
            profile.weeklyReportEnabled = self.weeklyReportEnabled
        }
    }

    func recalculateCalories() {
        let ageComponents = Calendar.current.dateComponents([.year], from: birthDate, to: Date())
        let age = ageComponents.year ?? 25
        let bmr = UserProfile.bmr(gender: gender, weight: targetWeight, height: height, age: age)
        let tdee = UserProfile.tdee(bmr: bmr, activityLevel: activityLevel)

        switch fitnessGoal {
        case "lose": dailyCalorieGoal = Int(tdee * 0.8)
        case "gain": dailyCalorieGoal = Int(tdee * 1.15)
        default: dailyCalorieGoal = Int(tdee)
        }
    }
}