import SwiftData
import Foundation

struct NutritionDailyPoint: Identifiable {
    let id = UUID()
    let date: Date
    let calories: Double
    let protein: Double
    let fat: Double
    let carbs: Double
}

struct WeightDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let weight: Double
}

struct ExerciseDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let duration: Int
    let calories: Double
}

@Observable
final class TrendsViewModel {
    var selectedTab: TrendsTab = .weight

    var weightData: [WeightDataPoint] = []
    var calorieData: [NutritionDailyPoint] = []
    var exerciseData: [ExerciseDataPoint] = []
    var nutritionData: [NutritionDailyPoint] = []

    var timeRange: TrendsTimeRange = .week

    var weightTrend: String = "—"
    var calorieTrend: String = "—"

    private var measurementRepo: BodyMeasurementRepository?
    private var nutritionRepo: NutritionRepository?
    private var workoutRepo: WorkoutRepository?

    func configure(context: ModelContext) {
        measurementRepo = BodyMeasurementRepository(modelContext: context)
        nutritionRepo = NutritionRepository(modelContext: context)
        workoutRepo = WorkoutRepository(modelContext: context)
    }

    func loadData() async {
        await loadWeightData()
        await loadCalorieData()
        await loadExerciseData()
    }

    private func loadWeightData() async {
        guard let repo = measurementRepo else { return }
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: timeRange.component, value: -timeRange.value, to: endDate) ?? endDate

        do {
            let measurements = try repo.measurements(from: startDate, to: endDate)
            await MainActor.run {
                self.weightData = measurements.map { WeightDataPoint(date: $0.recordedAt, weight: $0.weight) }
                if weightData.count >= 2 {
                    let diff = weightData.last!.weight - weightData.first!.weight
                    self.weightTrend = String(format: "%+.1f kg", diff)
                }
            }
        } catch {
            // 空数据
        }
    }

    private func loadCalorieData() async {
        guard let nutritionRepo = nutritionRepo else { return }
        let endDate = Date()
        let calendar = Calendar.current
        let days = timeRange == .year ? 30 : timeRange.value

        var points: [NutritionDailyPoint] = []
        for i in (0..<days).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -i, to: endDate) else { continue }
            do {
                let summary = try nutritionRepo.dailyNutritionSummary(for: date)
                points.append(NutritionDailyPoint(
                    date: calendar.startOfDay(for: date),
                    calories: summary.calories,
                    protein: summary.protein,
                    fat: summary.fat,
                    carbs: summary.carbs
                ))
            } catch {
                points.append(NutritionDailyPoint(
                    date: calendar.startOfDay(for: date),
                    calories: 0, protein: 0, fat: 0, carbs: 0
                ))
            }
        }

        await MainActor.run {
            self.calorieData = points
            self.nutritionData = points
            let consumed = points.filter { $0.calories > 0 }
            if consumed.count >= 2 {
                let avg = consumed.reduce(0.0) { $0 + $1.calories } / Double(consumed.count)
                self.calorieTrend = String(format: "日均 %.0f kcal", avg)
            }
        }
    }

    private func loadExerciseData() async {
        guard let workoutRepo = workoutRepo else { return }
        let endDate = Date()
        let calendar = Calendar.current
        let days = timeRange == .year ? 30 : timeRange.value

        var points: [ExerciseDataPoint] = []
        for i in (0..<days).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -i, to: endDate) else { continue }
            do {
                let duration = try workoutRepo.totalExerciseDuration(in: date)
                let workouts = try workoutRepo.workouts(for: date)
                let calories = workouts.reduce(0.0) { $0 + $1.caloriesBurned }
                points.append(ExerciseDataPoint(
                    date: calendar.startOfDay(for: date),
                    duration: duration,
                    calories: calories
                ))
            } catch {
                points.append(ExerciseDataPoint(
                    date: calendar.startOfDay(for: date),
                    duration: 0, calories: 0
                ))
            }
        }

        await MainActor.run {
            self.exerciseData = points
        }
    }
}

enum TrendsTab: String, CaseIterable {
    case weight = "体重"
    case calories = "热量"
    case exercise = "运动"
    case nutrition = "营养"
}

enum TrendsTimeRange: String, CaseIterable {
    case week = "周"
    case month = "月"
    case threeMonths = "3月"
    case year = "年"

    var component: Calendar.Component {
        switch self {
        case .week: return .day
        case .month: return .day
        case .threeMonths: return .day
        case .year: return .month
        }
    }

    var value: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .threeMonths: return 90
        case .year: return 365
        }
    }
}