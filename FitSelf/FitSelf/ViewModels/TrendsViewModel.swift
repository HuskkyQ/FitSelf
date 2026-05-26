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

@Observable
final class TrendsViewModel {
    var selectedTab: TrendsTab = .weight

    var weightData: [WeightDataPoint] = []
    var calorieData: [NutritionDailyPoint] = []
    var exerciseMinutesData: [(date: Date, minutes: Int)] = []

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
        guard let _ = nutritionRepo else { return }
        // TODO: 加载每日卡路里趋势
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