import SwiftUI
import SwiftData
import Charts

struct TrendsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = TrendsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    timeRangePicker

                    tabPicker

                    switch viewModel.selectedTab {
                    case .weight:
                        weightChart
                    case .calories:
                        calorieChart
                    case .exercise:
                        exerciseChart
                    case .nutrition:
                        nutritionChart
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(Color.appBackground)
            .navigationTitle("趋势")
            .task {
                viewModel.configure(context: modelContext)
                await viewModel.loadData()
            }
            .refreshable {
                await viewModel.loadData()
            }
        }
    }

    private var timeRangePicker: some View {
        Picker("时间范围", selection: $viewModel.timeRange) {
            ForEach(TrendsTimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
    }

    private var tabPicker: some View {
        Picker("数据类型", selection: $viewModel.selectedTab) {
            ForEach(TrendsTab.allCases, id: \.self) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
    }

    private var weightChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("体重趋势")
                    .font(.appTitle3)
                    .foregroundStyle(Color.appForeground)

                Spacer()

                Text(viewModel.weightTrend)
                    .font(.appCallout)
                    .foregroundStyle(viewModel.weightTrend.hasPrefix("-") ? Color.appAccent : Color.appDestructive)
            }

            if viewModel.weightData.isEmpty {
                emptyChartPlaceholder(message: "还没有体重记录\n开始记录你的体重吧")
            } else {
                Chart(viewModel.weightData) { point in
                    LineMark(x: .value("日期", point.date), y: .value("体重", point.weight))
                        .foregroundStyle(Color.chartExercise)
                        .interpolationMethod(.catmullRom)

                    PointMark(x: .value("日期", point.date), y: .value("体重", point.weight))
                        .foregroundStyle(Color.chartExercise)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 200)
            }
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var calorieChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("热量趋势")
                    .font(.appTitle3)
                    .foregroundStyle(Color.appForeground)

                Spacer()

                if !viewModel.calorieTrend.isEmpty && viewModel.calorieTrend != "—" {
                    Text(viewModel.calorieTrend)
                        .font(.appCallout)
                        .foregroundStyle(Color.appMutedForeground)
                }
            }

            if viewModel.calorieData.isEmpty || viewModel.calorieData.allSatisfy({ $0.calories == 0 }) {
                emptyChartPlaceholder(message: "还没有饮食记录\n记录你的饮食来查看趋势")
            } else {
                let consumed = viewModel.calorieData.filter { $0.calories > 0 }
                Chart(consumed) { point in
                    BarMark(x: .value("日期", point.date, unit: .day), y: .value("热量", point.calories))
                        .foregroundStyle(Color.chartCalories.gradient)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 200)
            }
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var exerciseChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("运动趋势")
                .font(.appTitle3)
                .foregroundStyle(Color.appForeground)

            if viewModel.exerciseData.isEmpty || viewModel.exerciseData.allSatisfy({ $0.duration == 0 }) {
                emptyChartPlaceholder(message: "还没有运动记录\n完成训练后查看趋势")
            } else {
                let exercised = viewModel.exerciseData.filter { $0.duration > 0 }
                Chart(exercised) { point in
                    BarMark(x: .value("日期", point.date, unit: .day), y: .value("时长(分钟)", point.duration))
                        .foregroundStyle(Color.chartExercise.gradient)

                    LineMark(x: .value("日期", point.date), y: .value("热量", point.calories))
                        .foregroundStyle(Color.chartCalories)
                        .interpolationMethod(.catmullRom)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 200)

                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.chartExercise)
                            .frame(width: 12, height: 12)
                        Text("时长(分钟)")
                            .font(.appCaption2)
                            .foregroundStyle(Color.appMutedForeground)
                    }
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.chartCalories)
                            .frame(width: 12, height: 12)
                        Text("消耗热量")
                            .font(.appCaption2)
                            .foregroundStyle(Color.appMutedForeground)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var nutritionChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("营养趋势")
                .font(.appTitle3)
                .foregroundStyle(Color.appForeground)

            if viewModel.nutritionData.isEmpty || viewModel.nutritionData.allSatisfy({ $0.calories == 0 }) {
                emptyChartPlaceholder(message: "还没有饮食记录\n记录饮食来查看营养趋势")
            } else {
                let consumed = viewModel.nutritionData.filter { $0.calories > 0 }
                Chart(consumed) { point in
                    LineMark(x: .value("日期", point.date), y: .value("蛋白质", point.protein))
                        .foregroundStyle(Color.chartProtein)
                        .interpolationMethod(.catmullRom)

                    LineMark(x: .value("日期", point.date), y: .value("碳水", point.carbs))
                        .foregroundStyle(Color.chartCarbs)
                        .interpolationMethod(.catmullRom)

                    LineMark(x: .value("日期", point.date), y: .value("脂肪", point.fat))
                        .foregroundStyle(Color.chartFat)
                        .interpolationMethod(.catmullRom)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 200)

                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Circle().fill(Color.chartProtein).frame(width: 8, height: 8)
                        Text("蛋白质")
                            .font(.appCaption2)
                            .foregroundStyle(Color.appMutedForeground)
                    }
                    HStack(spacing: 4) {
                        Circle().fill(Color.chartCarbs).frame(width: 8, height: 8)
                        Text("碳水")
                            .font(.appCaption2)
                            .foregroundStyle(Color.appMutedForeground)
                    }
                    HStack(spacing: 4) {
                        Circle().fill(Color.chartFat).frame(width: 8, height: 8)
                        Text("脂肪")
                            .font(.appCaption2)
                            .foregroundStyle(Color.appMutedForeground)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func emptyChartPlaceholder(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 36))
                .foregroundStyle(Color.appMuted)
            Text(message)
                .font(.appCallout)
                .foregroundStyle(Color.appMutedForeground)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}