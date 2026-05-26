import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = SettingsViewModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    profileSection

                    goalsSection

                    macroSection

                    notificationsSection

                    unitsSection

                    aboutSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(Color.appBackground)
            .navigationTitle("设置")
            .task {
                viewModel.configure(context: modelContext)
            }
        }
    }

    // MARK: - 个人信息

    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("个人信息")
                .font(.appTitle3)
                .foregroundStyle(Color.appForeground)

            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundStyle(Color.appPrimary)
                    Text("昵称")
                    Spacer()
                    TextField("你的名字", text: $viewModel.nickname)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(Color.appMutedForeground)
                }

                Divider()

                HStack {
                    Image(systemName: "figure.stand")
                        .foregroundStyle(Color.appPrimary)
                    Text("性别")
                    Spacer()
                    Picker("", selection: $viewModel.gender) {
                        Text("男").tag("male")
                        Text("女").tag("female")
                        Text("其他").tag("other")
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 180)
                }

                Divider()

                DatePicker(selection: $viewModel.birthDate, displayedComponents: .date) {
                    Label("出生日期", systemImage: "calendar")
                }

                Divider()

                HStack {
                    Image(systemName: "ruler")
                        .foregroundStyle(Color.appPrimary)
                    Text("身高")
                    Spacer()
                    TextField("170", value: $viewModel.height, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text("cm")
                        .foregroundStyle(Color.appMutedForeground)
                }

                Divider()

                HStack {
                    Image(systemName: "target")
                        .foregroundStyle(Color.appPrimary)
                    Text("目标体重")
                    Spacer()
                    TextField("65", value: $viewModel.targetWeight, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text("kg")
                        .foregroundStyle(Color.appMutedForeground)
                }
            }
            .padding(16)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - 目标（垂直卡片布局）

    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("每日目标")
                .font(.appTitle3)
                .foregroundStyle(Color.appForeground)

            VStack(spacing: 12) {
                goalCard(
                    icon: "flame.fill",
                    iconColor: .chartCalories,
                    title: "卡路里",
                    value: $viewModel.dailyCalorieGoal,
                    unit: "kcal",
                    progress: 0,
                    progressColor: .chartCalories
                )

                goalCard(
                    icon: "figure.run",
                    iconColor: .chartExercise,
                    title: "运动时长",
                    value: $viewModel.dailyExerciseGoal,
                    unit: "分钟",
                    progress: 0,
                    progressColor: .chartExercise
                )

                goalCard(
                    icon: "drop.fill",
                    iconColor: .chartWater,
                    title: "饮水量",
                    value: $viewModel.dailyWaterGoal,
                    unit: "ml",
                    progress: 0,
                    progressColor: .chartWater
                )
            }

            Button("重新计算推荐值") {
                viewModel.recalculateCalories()
            }
            .font(.appCallout)
            .foregroundStyle(Color.appPrimary)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private func goalCard(icon: String, iconColor: Color, title: String, value: Binding<Int>, unit: String, progress: Double, progressColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
                    .font(.title3)

                Text(title)
                    .font(.appCallout)
                    .foregroundStyle(Color.appForeground)

                Spacer()

                HStack(spacing: 4) {
                    TextField("0", value: value, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .font(.appTitle3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.appForeground)
                        .frame(width: 60)

                    Text(unit)
                        .font(.appCaption)
                        .foregroundStyle(Color.appMutedForeground)
                }
            }

            ProgressView(value: progress)
                .tint(progressColor)
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - 宏量营养素

    private var macroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("宏量营养素比例")
                .font(.appTitle3)
                .foregroundStyle(Color.appForeground)

            VStack(spacing: 16) {
                macroSlider(label: "碳水化合物", ratio: $viewModel.macroRatioCarbs, color: .chartCarbs)
                macroSlider(label: "蛋白质", ratio: $viewModel.macroRatioProtein, color: .chartProtein)
                macroSlider(label: "脂肪", ratio: $viewModel.macroRatioFat, color: .chartFat)
            }
            .padding(16)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func macroSlider(label: String, ratio: Binding<Double>, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.appCallout)
                    .foregroundStyle(Color.appForeground)
                Spacer()
                Text(String(format: "%.0f%%", ratio.wrappedValue * 100))
                    .font(.appCallout)
                    .foregroundStyle(color)
                    .fontWeight(.bold)
            }
            Slider(value: ratio, in: 0.05...0.65, step: 0.05)
                .tint(color)
        }
    }

    // MARK: - 通知

    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("通知提醒")
                .font(.appTitle3)
                .foregroundStyle(Color.appForeground)

            VStack(spacing: 0) {
                Toggle(isOn: $viewModel.weightReminderEnabled) {
                    Label("称重提醒", systemImage: "scalemass.fill")
                }
                .padding(.vertical, 8)

                Divider()

                Toggle(isOn: $viewModel.exerciseReminderEnabled) {
                    Label("运动提醒", systemImage: "figure.run")
                }
                .padding(.vertical, 8)

                Divider()

                Toggle(isOn: $viewModel.waterReminderEnabled) {
                    Label("喝水提醒", systemImage: "drop.fill")
                }
                .padding(.vertical, 8)

                Divider()

                Toggle(isOn: $viewModel.weeklyReportEnabled) {
                    Label("周报推送", systemImage: "chart.bar.fill")
                }
                .padding(.vertical, 8)
            }
            .padding(16)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - 单位

    private var unitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("单位设置")
                .font(.appTitle3)
                .foregroundStyle(Color.appForeground)

            VStack(spacing: 12) {
                HStack {
                    Text("体重单位")
                    Spacer()
                    Picker("", selection: $viewModel.unitWeight) {
                        Text("kg").tag("kg")
                        Text("lb").tag("lb")
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 120)
                }

                Divider()

                HStack {
                    Text("外观主题")
                    Spacer()
                    Picker("", selection: $viewModel.appearanceTheme) {
                        Text("跟随系统").tag("system")
                        Text("浅色").tag("light")
                        Text("深色").tag("dark")
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 200)
                }
            }
            .padding(16)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - 关于

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("关于")
                .font(.appTitle3)
                .foregroundStyle(Color.appForeground)

            VStack(spacing: 0) {
                HStack {
                    Text("FitSelf")
                        .font(.appTitle3)
                    Spacer()
                    Text("v1.0.0")
                        .font(.appCallout)
                        .foregroundStyle(Color.appMutedForeground)
                }
                .padding(.vertical, 8)

                Divider()

                HStack {
                    Text("免费开源，无广告无订阅")
                        .font(.appCaption)
                        .foregroundStyle(Color.appMutedForeground)
                    Spacer()
                }
                .padding(.vertical, 8)
            }
            .padding(16)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}