import SwiftUI

struct OnboardingView: View {
    @State private var viewModel = OnboardingViewModel()
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                TabView(selection: $viewModel.currentStep) {
                    OnboardingStep1View(viewModel: viewModel)
                        .tag(0)
                    OnboardingStep2View(viewModel: viewModel)
                        .tag(1)
                    OnboardingStep3View(viewModel: viewModel)
                        .tag(2)
                    OnboardingStep4View(viewModel: viewModel)
                        .tag(3)
                    OnboardingStep5View(viewModel: viewModel)
                        .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: geometry.size.height - 100)

                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        ForEach(0..<viewModel.totalSteps, id: \.self) { step in
                            Circle()
                                .fill(step == viewModel.currentStep ? Color.appPrimary : Color.appMuted)
                                .frame(width: 8, height: 8)
                        }
                    }

                    HStack {
                        if viewModel.currentStep > 0 {
                            Button("上一步") {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    viewModel.currentStep -= 1
                                }
                            }
                            .foregroundStyle(Color.appMutedForeground)
                        }

                        Spacer()

                        Button(viewModel.currentStep == viewModel.totalSteps - 1 ? "开始使用" : "下一步") {
                            if viewModel.currentStep == viewModel.totalSteps - 1 {
                                do {
                                    try viewModel.saveProfile(context: modelContext)
                                    withAnimation {
                                        hasCompletedOnboarding = true
                                    }
                                } catch {
                                    // TODO: 错误处理
                                }
                            } else {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    viewModel.currentStep += 1
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.appPrimary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .background(Color.appBackground)
    }
}

struct OnboardingStep1View: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("👋")
                    .font(.system(size: 48))

                Text("欢迎来到 FitSelf")
                    .font(.appTitle1)
                    .foregroundStyle(Color.appForeground)

                Text("了解你的身体，看见变化")
                    .font(.appBody)
                    .foregroundStyle(Color.appMutedForeground)

                VStack(spacing: 16) {
                    Picker("性别", selection: $viewModel.gender) {
                        Text("男").tag("male")
                        Text("女").tag("female")
                        Text("其他").tag("other")
                    }
                    .pickerStyle(.segmented)

                    DatePicker("出生日期", selection: $viewModel.birthDate, displayedComponents: .date)

                    HStack {
                        Text("身高")
                        Spacer()
                        TextField("170", value: $viewModel.height, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("cm")
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 50)
            .padding(.bottom, 30)
        }
    }
}

struct OnboardingStep2View: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("⚖️")
                    .font(.system(size: 48))

                Text("你的当前身体数据")
                    .font(.appTitle1)
                    .foregroundStyle(Color.appForeground)

                VStack(spacing: 16) {
                    HStack {
                        Text("体重")
                        Spacer()
                        TextField("65", value: $viewModel.weight, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("kg")
                    }

                    HStack {
                        Text("体脂率（可选）")
                        Spacer()
                        TextField("20", value: $viewModel.bodyFatPercentage, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("%")
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 50)
            .padding(.bottom, 30)
        }
    }
}

struct OnboardingStep3View: View {
    @Bindable var viewModel: OnboardingViewModel

    let goals = [
        ("lose", "减脂", "减少体脂肪，塑造更精瘦的体型", "flame.fill"),
        ("gain", "增肌", "增加肌肉量，变得更强壮", "dumbbell.fill"),
        ("maintain", "维持", "保持当前体型和健康状态", "heart.fill"),
        ("shape", "塑形", "改善体态，增强柔韧和力量", "figure.yoga")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("你的健身目标是什么？")
                    .font(.appTitle1)
                    .foregroundStyle(Color.appForeground)

                Text("我们会根据你的目标定制推荐计划")
                    .font(.appBody)
                    .foregroundStyle(Color.appMutedForeground)

                VStack(spacing: 12) {
                    ForEach(goals, id: \.0) { value, title, desc, icon in
                        Button {
                            viewModel.fitnessGoal = value
                        } label: {
                            HStack(spacing: 16) {
                                Image(systemName: icon)
                                    .font(.title3)
                                    .foregroundStyle(viewModel.fitnessGoal == value ? Color.appPrimary : Color.appMutedForeground)
                                    .frame(width: 44, height: 44)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(title)
                                        .font(.appTitle3)
                                        .foregroundStyle(Color.appForeground)
                                    Text(desc)
                                        .font(.appFootnote)
                                        .foregroundStyle(Color.appMutedForeground)
                                }

                                Spacer()

                                if viewModel.fitnessGoal == value {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.appPrimary)
                                }
                            }
                            .padding(16)
                            .background(viewModel.fitnessGoal == value ? Color.appPrimary.opacity(0.1) : Color.appCard)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(viewModel.fitnessGoal == value ? Color.appPrimary : Color.appBorder, lineWidth: viewModel.fitnessGoal == value ? 2 : 1)
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 50)
            .padding(.bottom, 30)
        }
    }
}

struct OnboardingStep4View: View {
    @Bindable var viewModel: OnboardingViewModel

    let levels = [
        ("sedentary", "久坐", "办公室工作，很少运动"),
        ("light", "轻量活动", "每周运动1-3次"),
        ("moderate", "中等活动", "每周运动3-5次"),
        ("heavy", "重度活动", "每周运动6-7次")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("你的活动水平？")
                    .font(.appTitle1)
                    .foregroundStyle(Color.appForeground)

                VStack(spacing: 12) {
                    ForEach(levels, id: \.0) { value, title, desc in
                        Button {
                            viewModel.activityLevel = value
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(title)
                                        .font(.appTitle3)
                                        .foregroundStyle(Color.appForeground)
                                    Text(desc)
                                        .font(.appFootnote)
                                        .foregroundStyle(Color.appMutedForeground)
                                }
                                Spacer()
                                if viewModel.activityLevel == value {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.appPrimary)
                                }
                            }
                            .padding(16)
                            .background(viewModel.activityLevel == value ? Color.appPrimary.opacity(0.1) : Color.appCard)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(viewModel.activityLevel == value ? Color.appPrimary : Color.appBorder, lineWidth: viewModel.activityLevel == value ? 2 : 1)
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 50)
            .padding(.bottom, 30)
        }
    }
}

struct OnboardingStep5View: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("🎯")
                    .font(.system(size: 48))

                Text("目标设定")
                    .font(.appTitle1)
                    .foregroundStyle(Color.appForeground)

                Text("我们为你计算了推荐目标，你可以手动调整")
                    .font(.appBody)
                    .foregroundStyle(Color.appMutedForeground)

                VStack(spacing: 16) {
                    HStack {
                        Text("每日卡路里")
                        Spacer()
                        TextField("2000", value: $viewModel.dailyCalorieGoal, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("kcal")
                    }

                    HStack {
                        Text("每日运动")
                        Spacer()
                        TextField("60", value: $viewModel.dailyExerciseGoal, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("分钟")
                    }

                    HStack {
                        Text("每日饮水")
                        Spacer()
                        TextField("2000", value: $viewModel.dailyWaterGoal, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("ml")
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 50)
            .padding(.bottom, 30)
        }
    }
}