import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = SettingsViewModel()
    @State private var isEditingProfile = false

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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        try? viewModel.saveProfile()
                    } label: {
                        Text("保存")
                            .font(.appCallout)
                            .foregroundStyle(Color.appPrimary)
                    }
                }
            }
            .task {
                viewModel.configure(context: modelContext)
            }
        }
    }

    // MARK: - 个人信息（只读展示 + 编辑按钮）

    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("个人信息")
                    .font(.appTitle3)
                    .foregroundStyle(Color.appForeground)

                Spacer()

                Button {
                    isEditingProfile = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                            .font(.appCaption)
                        Text("编辑")
                            .font(.appCallout)
                    }
                    .foregroundStyle(Color.appPrimary)
                }
            }

            VStack(spacing: 12) {
                profileRow(icon: "person.circle.fill", label: "昵称", value: viewModel.nickname.isEmpty ? "未设置" : viewModel.nickname)
                profileRow(icon: "figure.stand", label: "性别", value: genderText)
                profileRow(icon: "calendar", label: "出生日期", value: viewModel.birthDate.formatted(date: .abbreviated, time: .omitted))
                profileRow(icon: "ruler", label: "身高", value: "\(Int(viewModel.height)) cm")
                profileRow(icon: "target", label: "目标体重", value: "\(Int(viewModel.targetWeight)) kg")
                profileRow(icon: "figure.run", label: "活动水平", value: activityLevelText)
                profileRow(icon: "flame.fill", label: "健身目标", value: fitnessGoalText)
            }
            .padding(16)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .sheet(isPresented: $isEditingProfile) {
            ProfileEditorView(viewModel: viewModel)
        }
    }

    private func profileRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(Color.appPrimary)
                .frame(width: 24)
            Text(label)
                .font(.appCallout)
                .foregroundStyle(Color.appForeground)
            Spacer()
            Text(value)
                .font(.appCallout)
                .foregroundStyle(Color.appMutedForeground)
        }
    }

    private var genderText: String {
        switch viewModel.gender {
        case "male": return "男"
        case "female": return "女"
        default: return "其他"
        }
    }

    private var activityLevelText: String {
        switch viewModel.activityLevel {
        case "sedentary": return "久坐"
        case "light": return "轻量活动"
        case "moderate": return "中等活动"
        case "heavy": return "重度活动"
        default: return "中等活动"
        }
    }

    private var fitnessGoalText: String {
        switch viewModel.fitnessGoal {
        case "lose": return "减脂"
        case "gain": return "增肌"
        case "maintain": return "维持"
        case "shape": return "塑形"
        default: return "维持"
        }
    }

    // MARK: - 每日目标（只读展示 + 编辑按钮）

    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("每日目标")
                .font(.appTitle3)
                .foregroundStyle(Color.appForeground)

            VStack(spacing: 12) {
                goalDisplayRow(icon: "flame.fill", iconColor: Color.chartCalories, title: "卡路里", value: "\(viewModel.dailyCalorieGoal) kcal")
                goalDisplayRow(icon: "figure.run", iconColor: Color.chartExercise, title: "运动时长", value: "\(viewModel.dailyExerciseGoal) 分钟")
                goalDisplayRow(icon: "drop.fill", iconColor: Color.chartWater, title: "饮水量", value: "\(viewModel.dailyWaterGoal) ml")
            }
        }
    }

    private func goalDisplayRow(icon: String, iconColor: Color, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .font(.title3)
            Text(title)
                .font(.appCallout)
                .foregroundStyle(Color.appForeground)
            Spacer()
            Text(value)
                .font(.appCallout)
                .fontWeight(.bold)
                .foregroundStyle(Color.appForeground)
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - 宏量营养素（只读展示）

    private var macroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("宏量营养素比例")
                .font(.appTitle3)
                .foregroundStyle(Color.appForeground)

            VStack(spacing: 12) {
                macroDisplayRow(label: "碳水化合物", percent: Int(viewModel.macroRatioCarbs * 100), color: Color.chartCarbs)
                macroDisplayRow(label: "蛋白质", percent: Int(viewModel.macroRatioProtein * 100), color: Color.chartProtein)
                macroDisplayRow(label: "脂肪", percent: Int(viewModel.macroRatioFat * 100), color: Color.chartFat)
            }
            .padding(16)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func macroDisplayRow(label: String, percent: Int, color: Color) -> some View {
        HStack {
            Text(label)
                .font(.appCallout)
                .foregroundStyle(Color.appForeground)
            Spacer()
            Text("\(percent)%")
                .font(.appCallout)
                .fontWeight(.bold)
                .foregroundStyle(color)
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

// MARK: - 个人信息编辑弹窗

struct ProfileEditorView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("基本信息") {
                    TextField("昵称", text: $viewModel.nickname)

                    Picker("性别", selection: $viewModel.gender) {
                        Text("男").tag("male")
                        Text("女").tag("female")
                        Text("其他").tag("other")
                    }

                    DatePicker("出生日期", selection: $viewModel.birthDate, displayedComponents: .date)

                    HStack {
                        Text("身高")
                        Spacer()
                        TextField("170", value: $viewModel.height, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("cm")
                    }

                    HStack {
                        Text("目标体重")
                        Spacer()
                        TextField("65", value: $viewModel.targetWeight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("kg")
                    }
                }

                Section("运动设置") {
                    Picker("活动水平", selection: $viewModel.activityLevel) {
                        Text("久坐").tag("sedentary")
                        Text("轻量活动").tag("light")
                        Text("中等活动").tag("moderate")
                        Text("重度活动").tag("heavy")
                    }

                    Picker("健身目标", selection: $viewModel.fitnessGoal) {
                        Text("减脂").tag("lose")
                        Text("增肌").tag("gain")
                        Text("维持").tag("maintain")
                        Text("塑形").tag("shape")
                    }
                }

                Section("每日目标") {
                    HStack {
                        Text("卡路里")
                        Spacer()
                        TextField("2000", value: $viewModel.dailyCalorieGoal, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("kcal")
                    }

                    HStack {
                        Text("运动时长")
                        Spacer()
                        TextField("60", value: $viewModel.dailyExerciseGoal, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("分钟")
                    }

                    HStack {
                        Text("饮水量")
                        Spacer()
                        TextField("2000", value: $viewModel.dailyWaterGoal, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("ml")
                    }

                    Button("重新计算推荐值") {
                        viewModel.recalculateCalories()
                    }
                    .foregroundStyle(Color.appPrimary)
                }

                Section("宏量营养素比例") {
                    VStack(spacing: 8) {
                        HStack {
                            Text("碳水化合物")
                            Spacer()
                            Text("\(Int(viewModel.macroRatioCarbs * 100))%")
                                .foregroundStyle(Color.chartCarbs)
                        }
                        Slider(value: $viewModel.macroRatioCarbs, in: 0.05...0.65, step: 0.05)
                            .tint(Color.chartCarbs)
                    }

                    VStack(spacing: 8) {
                        HStack {
                            Text("蛋白质")
                            Spacer()
                            Text("\(Int(viewModel.macroRatioProtein * 100))%")
                                .foregroundStyle(Color.chartProtein)
                        }
                        Slider(value: $viewModel.macroRatioProtein, in: 0.05...0.65, step: 0.05)
                            .tint(Color.chartProtein)
                    }

                    VStack(spacing: 8) {
                        HStack {
                            Text("脂肪")
                            Spacer()
                            Text("\(Int(viewModel.macroRatioFat * 100))%")
                                .foregroundStyle(Color.chartFat)
                        }
                        Slider(value: $viewModel.macroRatioFat, in: 0.05...0.65, step: 0.05)
                            .tint(Color.chartFat)
                    }
                }
            }
            .navigationTitle("编辑个人信息")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}