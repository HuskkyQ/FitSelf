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
            Text("热量趋势")
                .font(.appTitle3)
                .foregroundStyle(Color.appForeground)

            if viewModel.calorieData.isEmpty {
                emptyChartPlaceholder(message: "还没有饮食记录\n记录你的饮食来查看趋势")
            } else {
                Chart(viewModel.calorieData) { point in
                    BarMark(x: .value("日期", point.date), y: .value("热量", point.calories))
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

            emptyChartPlaceholder(message: "运动趋势图表即将推出")
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

            emptyChartPlaceholder(message: "营养趋势图表即将推出")
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