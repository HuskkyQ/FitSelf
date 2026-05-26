import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = WorkoutViewModel()
    @State private var showingExercisePicker = false
    @State private var showingCustomExercise = false
    @State private var showingWorkoutHistory = false
    @State private var editingExerciseIndex: Int?
    @State private var editingExerciseSets: [EditSetDetail] = []
    @State private var exerciseToAdd: WorkoutType?
    @State private var timerScaleProgress: CGFloat = 0

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isWorkoutActive {
                    activeWorkoutView
                } else {
                    workoutStartView
                }
            }
            .background(Color.appBackground)
            .navigationTitle(viewModel.isWorkoutActive ? viewModel.workoutCategoryDisplayName : "运动")
            .toolbar {
                if viewModel.isWorkoutActive {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("取消") {
                            viewModel.cancelWorkout()
                        }
                        .foregroundStyle(Color.appDestructive)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("完成") {
                            do {
                                try viewModel.finishWorkout()
                            } catch {}
                        }
                        .foregroundStyle(Color.appAccent)
                        .fontWeight(.bold)
                    }
                } else {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingWorkoutHistory = true
                        } label: {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundStyle(Color.appMutedForeground)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePickerView(
                    viewModel: viewModel,
                    category: viewModel.workoutCategory,
                    onSelect: { type in
                        exerciseToAdd = type
                    }
                )
            }
            .sheet(item: $exerciseToAdd) { type in
                AddExerciseSetsView(
                    exerciseName: type.name,
                    category: type.category,
                    onAdd: { sets, reps, weight in
                        viewModel.addExercise(name: type.name, category: type.category, defaultSets: sets, defaultReps: reps, defaultWeight: weight)
                        exerciseToAdd = nil
                    },
                    onCancel: {
                        exerciseToAdd = nil
                    }
                )
            }
            .sheet(isPresented: $showingCustomExercise) {
                CustomExerciseView(viewModel: viewModel, category: viewModel.workoutCategory)
            }
            .sheet(isPresented: $showingWorkoutHistory) {
                NavigationStack {
                    WorkoutHistoryView(viewModel: viewModel)
                }
            }
            .sheet(item: Binding(
                get: { editingExerciseIndex.map { IndexWrapper(index: $0) } },
                set: { editingExerciseIndex = $0?.index }
            )) { wrapper in
                if wrapper.index < viewModel.exercises.count {
                    EditExerciseSetsView(
                        exerciseName: viewModel.exercises[wrapper.index].exerciseName,
                        currentSets: editingExerciseSets,
                        onSave: { sets in
                            viewModel.updateExerciseSets(exerciseIndex: wrapper.index, sets: sets)
                            editingExerciseIndex = nil
                        },
                        onCancel: { editingExerciseIndex = nil }
                    )
                }
            }
            .task {
                viewModel.configure(context: modelContext)
            }
        }
    }

    private var workoutStartView: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "figure.run")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.appPrimary)

                    Text("开始一次运动")
                        .font(.appTitle2)
                        .foregroundStyle(Color.appForeground)

                    Text("记录你的训练，追踪每一次进步")
                        .font(.appBody)
                        .foregroundStyle(Color.appMutedForeground)
                }
                .padding(.top, 40)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    workoutCategoryButton(title: "力量训练", icon: "dumbbell.fill", category: "strength", color: Color.chartExercise)
                    workoutCategoryButton(title: "有氧运动", icon: "figure.run", category: "cardio", color: Color.chartCalories)
                    workoutCategoryButton(title: "柔韧拉伸", icon: "figure.yoga", category: "flexibility", color: Color.chartProtein)
                    workoutCategoryButton(title: "球类运动", icon: "basketball.fill", category: "sports", color: Color.chartCarbs)
                }
                .padding(.horizontal, 16)

                if !viewModel.recentWorkouts.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("最近训练")
                            .font(.appTitle3)
                            .foregroundStyle(Color.appForeground)

                        ForEach(viewModel.recentWorkouts.prefix(3)) { workout in
                            RecentWorkoutRow(workout: workout)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                }

                Spacer()
            }
        }
    }

    private func workoutCategoryButton(title: String, icon: String, category: String, color: Color) -> some View {
        Button {
            viewModel.startWorkout(category: category)
        } label: {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundStyle(color)

                Text(title)
                    .font(.appCallout)
                    .foregroundStyle(Color.appForeground)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var activeWorkoutView: some View {
        ScrollView {
            VStack(spacing: 16) {
                workoutTimerSection
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onChange(of: geo.frame(in: .named("scroll")).minY) { _, newY in
                                    let sectionHeight = geo.size.height + 16
                                    let progress = max(0, min(1, -newY / sectionHeight))
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        timerScaleProgress = progress
                                    }
                                }
                        }
                    )
                    .scaleEffect(x: 1, y: 1 - timerScaleProgress * 0.4, anchor: .top)
                    .opacity(1 - timerScaleProgress)

                exerciseListSection

                addExerciseButton

                if !viewModel.exercises.isEmpty {
                    workoutSummarySection
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .coordinateSpace(name: "scroll")
        .safeAreaInset(edge: .top, spacing: 0) {
            compactStatsBar
                .offset(y: timerScaleProgress > 0 ? 0 : -16)
                .opacity(timerScaleProgress)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            workoutBottomBar
        }
    }

    private var compactStatsBar: some View {
        HStack(spacing: 16) {
            VStack(spacing: 2) {
                Text("时长")
                    .font(.appCaption2)
                    .foregroundStyle(Color.appMutedForeground)
                Text("\(viewModel.totalDuration)分钟")
                    .font(.appCallout)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.appForeground)
            }
            .frame(maxWidth: .infinity)

            Divider().frame(height: 24)

            VStack(spacing: 2) {
                Text("热量")
                    .font(.appCaption2)
                    .foregroundStyle(Color.appMutedForeground)
                Text("\(Int(viewModel.totalCalories))kcal")
                    .font(.appCallout)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.chartCalories)
            }
            .frame(maxWidth: .infinity)

            Divider().frame(height: 24)

            VStack(spacing: 2) {
                Text("动作")
                    .font(.appCaption2)
                    .foregroundStyle(Color.appMutedForeground)
                Text("\(viewModel.exercises.count)个")
                    .font(.appCallout)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.appForeground)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(.ultraThinMaterial)
    }

    private var workoutTimerSection: some View {
        HStack(spacing: 20) {
            VStack(spacing: 4) {
                Text("运动时长")
                    .font(.appCaption)
                    .foregroundStyle(Color.appMutedForeground)
                Text("\(viewModel.totalDuration) 分钟")
                    .font(.appTitle3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.appForeground)
            }

            Divider().frame(height: 32)

            VStack(spacing: 4) {
                Text("消耗热量")
                    .font(.appCaption)
                    .foregroundStyle(Color.appMutedForeground)
                Text("\(Int(viewModel.totalCalories)) kcal")
                    .font(.appTitle3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.chartCalories)
            }

            Divider().frame(height: 32)

            VStack(spacing: 4) {
                Text("动作数")
                    .font(.appCaption)
                    .foregroundStyle(Color.appMutedForeground)
                Text("\(viewModel.exercises.count)")
                    .font(.appTitle3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.appForeground)
            }
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var exerciseListSection: some View {
        VStack(spacing: 12) {
            ForEach(Array(viewModel.exercises.enumerated()), id: \.element.id) { index, exercise in
                ExerciseCardView(
                    exercise: exercise,
                    onEdit: {
                        let ex = viewModel.exercises[index]
                        editingExerciseSets = ex.sets.sorted(by: { $0.setNumber < $1.setNumber }).map {
                            EditSetDetail(weight: $0.weight, reps: $0.reps, rpe: $0.rpe)
                        }
                        if editingExerciseSets.isEmpty {
                            editingExerciseSets = [EditSetDetail(weight: 0, reps: 0, rpe: nil)]
                        }
                        editingExerciseIndex = index
                    }
                )
            }
        }
    }

    private var addExerciseButton: some View {
        HStack(spacing: 12) {
            Button {
                showingExercisePicker = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("选择动作")
                }
                .font(.appCallout)
                .foregroundStyle(Color.appPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.appPrimary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button {
                showingCustomExercise = true
            } label: {
                HStack {
                    Image(systemName: "pencil.circle.fill")
                    Text("自定义")
                }
                .font(.appCallout)
                .foregroundStyle(Color.appMutedForeground)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.appCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var workoutSummarySection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("总组数")
                Spacer()
                Text("\(viewModel.exercises.reduce(0) { $0 + $1.sets.count })")
                    .fontWeight(.bold)
            }
            .font(.appCallout)
            .foregroundStyle(Color.appForeground)

            HStack {
                Text("总容量")
                Spacer()
                Text(String(format: "%.1f kg", viewModel.exercises.reduce(0.0) { $0 + $1.totalVolume }))
                    .fontWeight(.bold)
            }
            .font(.appCallout)
            .foregroundStyle(Color.appForeground)
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var workoutBottomBar: some View {
        HStack(spacing: 12) {
            Button("取消训练") {
                viewModel.cancelWorkout()
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.appDestructive)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button("完成训练") {
                do {
                    try viewModel.finishWorkout()
                } catch {}
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.appAccent)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - 动作卡片（全量展示 + 右上角编辑）

struct ExerciseCardView: View {
    let exercise: WorkoutExercise
    let onEdit: () -> Void

    @State private var showingRPEInfo = false

    private var sortedSets: [WorkoutSet] {
        exercise.sets.sorted { $0.setNumber < $1.setNumber }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(exercise.exerciseName)
                        .font(.appCallout)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.appForeground)

                    HStack(spacing: 6) {
                        Text("\(exercise.sets.count)组")
                        if exercise.totalVolume > 0 {
                            Text("·")
                            Text(String(format: "%.1fkg", exercise.totalVolume))
                        }
                    }
                    .font(.appCaption)
                    .foregroundStyle(Color.appMutedForeground)
                }

                Spacer()

                Button {
                    onEdit()
                } label: {
                    Image(systemName: "pencil.circle")
                        .font(.title3)
                        .foregroundStyle(Color.appPrimary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)
            .padding(.bottom, sortedSets.isEmpty ? 12 : 6)

            if !sortedSets.isEmpty {
                setsTable
                    .padding(.horizontal, 14)
                    .padding(.bottom, 12)
            }
        }
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .alert("RPE 主观疲劳度评分", isPresented: $showingRPEInfo) {
            Button("知道了") {}
        } message: {
            Text("RPE（Rating of Perceived Exertion）用于衡量每组训练的难度：\n\n1-2：非常轻松\n3-4：轻松\n5-6：中等\n7-8：困难\n9-10：极限\n\n建议大部分训练组保持在 7-8 的强度。")
        }
    }

    private var setsTable: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("#")
                    .frame(maxWidth: .infinity)
                Text("重量")
                    .frame(maxWidth: .infinity)
                Text("次数")
                    .frame(maxWidth: .infinity)
                Button {
                    showingRPEInfo = true
                } label: {
                    HStack(spacing: 2) {
                        Text("RPE")
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 10))
                    }
                    .frame(maxWidth: .infinity)
                }
                .foregroundStyle(Color.appMutedForeground)
            }
            .font(.appCaption2)
            .padding(.vertical, 6)

            Divider()

            ForEach(Array(sortedSets.enumerated()), id: \.element.id) { index, set in
                HStack(spacing: 0) {
                    Text("\(index + 1)")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.appMutedForeground)

                    Text(set.weight > 0 ? String(format: "%.1f", set.weight) : "—")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(set.weight > 0 ? Color.appForeground : Color.appMutedForeground)

                    Text(set.reps > 0 ? "\(set.reps)" : "—")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(set.reps > 0 ? Color.appForeground : Color.appMutedForeground)

                    if let rpe = set.rpe, rpe > 0 {
                        Text("\(rpe)")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.appPrimary)
                    } else {
                        Text("—")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.appMutedForeground)
                    }
                }
                .font(.appCaption)
                .padding(.vertical, 5)

                if index < sortedSets.count - 1 {
                    Divider()
                }
            }
        }
    }
}

// MARK: - 添加动作时设置组数、次数和重量

struct AddExerciseSetsView: View {
    let exerciseName: String
    let category: String
    let onAdd: (Int, Int, Double) -> Void
    let onCancel: () -> Void

    @State private var sets = 3
    @State private var reps = 10
    @State private var weight: Double = 0

    var body: some View {
        NavigationStack {
            Form {
                Section("动作") {
                    Text(exerciseName)
                        .font(.appCallout)
                        .foregroundStyle(Color.appForeground)
                }

                Section("初始设置") {
                    Stepper("组数: \(sets)", value: $sets, in: 1...20)

                    HStack {
                        Text("重量")
                        TextField("0", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                        Text("kg")
                    }

                    Stepper("次数: \(reps)", value: $reps, in: 1...100)

                    HStack {
                        Text("预览")
                            .foregroundStyle(Color.appMutedForeground)
                        Spacer()
                        Text("\(sets)组 × \(String(format: "%.1f", weight))kg × \(reps)次")
                            .foregroundStyle(Color.appForeground)
                    }
                }
            }
            .navigationTitle("添加动作")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { onCancel() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("添加") { onAdd(sets, reps, weight) }
                        .fontWeight(.bold)
                }
            }
        }
    }
}

// MARK: - 编辑动作组数（可编辑每组详情）

struct EditExerciseSetsView: View {
    let exerciseName: String
    let currentSets: [EditSetDetail]
    let onSave: ([EditSetDetail]) -> Void
    let onCancel: () -> Void

    @State private var sets: [EditSetDetail]
    @State private var showingRPEInfo = false

    init(exerciseName: String, currentSets: [EditSetDetail], onSave: @escaping ([EditSetDetail]) -> Void, onCancel: @escaping () -> Void) {
        self.exerciseName = exerciseName
        self.currentSets = currentSets
        self.onSave = onSave
        self.onCancel = onCancel
        _sets = State(initialValue: currentSets)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach($sets) { $set in
                        HStack(spacing: 12) {
                            Text("\(sets.firstIndex(where: { $0.id == set.id })! + 1)")
                                .font(.appCaption)
                                .foregroundStyle(Color.appMutedForeground)
                                .frame(width: 20)

                            TextField("0", value: $set.weight, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 64)

                            Text("kg")
                                .font(.appCaption)
                                .foregroundStyle(Color.appMutedForeground)

                            TextField("0", value: $set.reps, format: .number)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 48)

                            Text("次")
                                .font(.appCaption)
                                .foregroundStyle(Color.appMutedForeground)

                            TextField("0", value: $set.rpe, format: .number)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 40)

                            Text("RPE")
                                .font(.appCaption)
                                .foregroundStyle(Color.appMutedForeground)
                        }
                    }
                    .onDelete { indexSet in
                        sets.remove(atOffsets: indexSet)
                    }
                } header: {
                    HStack {
                        Text(exerciseName)
                        Spacer()
                        HStack(spacing: 4) {
                            Text("kg · 次")
                            Button {
                                showingRPEInfo = true
                            } label: {
                                HStack(spacing: 2) {
                                    Text("RPE")
                                    Image(systemName: "questionmark.circle.fill")
                                        .font(.caption2)
                                }
                            }
                            .foregroundStyle(Color.appMutedForeground)
                        }
                        .font(.appCaption2)
                    }
                }

                Section {
                    Button {
                        sets.append(EditSetDetail(weight: 0, reps: 0, rpe: nil))
                    } label: {
                        Label("添加一组", systemImage: "plus.circle.fill")
                    }
                    .foregroundStyle(Color.appPrimary)
                }
            }
            .navigationTitle("编辑组数")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { onCancel() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") {
                        onSave(sets.map { EditSetDetail(weight: $0.weight, reps: $0.reps, rpe: $0.rpe) })
                    }
                    .fontWeight(.bold)
                }
            }
            .alert("RPE 主观疲劳度评分", isPresented: $showingRPEInfo) {
                Button("知道了") {}
            } message: {
                Text("RPE（Rating of Perceived Exertion）用于衡量每组训练的难度：\n\n1-2：非常轻松\n3-4：轻松\n5-6：中等\n7-8：困难\n9-10：极限\n\n建议大部分训练组保持在 7-8 的强度。")
            }
        }
    }
}

// MARK: - IndexWrapper for sheet binding

class IndexWrapper: Identifiable {
    let id = UUID()
    let index: Int
    init(index: Int) { self.index = index }
}

// MARK: - ExercisePickerView

struct ExercisePickerView: View {
    let viewModel: WorkoutViewModel
    let category: String
    let onSelect: (WorkoutType) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var showingMETInfo = false

    var body: some View {
        NavigationStack {
            List {
                let types = WorkoutTypeStore.types(for: category)
                let filtered = searchText.isEmpty ? types : types.filter { $0.name.contains(searchText) }

                ForEach(filtered) { type in
                    Button {
                        onSelect(type)
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: type.icon)
                                .foregroundStyle(Color.appPrimary)
                                .frame(width: 32)

                            Text(type.name)
                                .font(.appCallout)
                                .foregroundStyle(Color.appForeground)

                            Spacer()

                            Text(String(format: "MET %.1f", type.metValue))
                                .font(.appCaption2)
                                .foregroundStyle(Color.appMutedForeground)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle(categoryDisplayName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingMETInfo = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(Color.appMutedForeground)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("取消") { dismiss() }
                }
            }
            .searchable(text: $searchText, prompt: "搜索动作")
            .alert("MET 代谢当量", isPresented: $showingMETInfo) {
                Button("知道了") {}
            } message: {
                Text("MET（Metabolic Equivalent of Task）衡量运动强度：\n\n1 MET = 静坐状态耗氧量（约 3.5ml/kg/min）\n\n值越高热量消耗越大：\n· 3-4 MET：低强度（瑜伽、散步）\n· 5-7 MET：中强度（力量训练、慢跑）\n· 8-10 MET：高强度（跑步、跳绳）\n· 10+ MET：极高强度（冲刺、HIIT）")
            }
        }
    }

    private var categoryDisplayName: String {
        switch category {
        case "strength": return "力量训练"
        case "cardio": return "有氧运动"
        case "flexibility": return "柔韧拉伸"
        case "sports": return "球类运动"
        case "water": return "水上运动"
        case "outdoor": return "户外运动"
        default: return "选择动作"
        }
    }
}

struct CustomExerciseView: View {
    let viewModel: WorkoutViewModel
    let category: String
    @Environment(\.dismiss) private var dismiss
    @State private var exerciseName = ""
    @State private var sets = 3
    @State private var reps = 10
    @State private var weight: Double = 0

    var body: some View {
        NavigationStack {
            Form {
                Section("自定义动作") {
                    TextField("动作名称", text: $exerciseName)
                }

                Section("初始设置") {
                    Stepper("组数: \(sets)", value: $sets, in: 1...20)

                    HStack {
                        Text("重量")
                        TextField("0", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                        Text("kg")
                    }

                    Stepper("次数: \(reps)", value: $reps, in: 1...100)
                }
            }
            .navigationTitle("添加自定义动作")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("添加") {
                        guard !exerciseName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        viewModel.addExercise(name: exerciseName.trimmingCharacters(in: .whitespaces), category: category, defaultSets: sets, defaultReps: reps, defaultWeight: weight)
                        dismiss()
                    }
                    .disabled(exerciseName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }
                }
            }
        }
    }
}

struct WorkoutHistoryView: View {
    let viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss

    private let categoryNames: [String: String] = [
        "strength": "力量训练", "cardio": "有氧运动", "flexibility": "柔韧拉伸",
        "sports": "球类运动", "water": "水上运动", "outdoor": "户外运动"
    ]

    var body: some View {
        List(viewModel.recentWorkouts) { workout in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(categoryNames[workout.workoutCategory, default: "运动"])
                        .font(.appTitle3)
                        .foregroundStyle(Color.appForeground)

                    Spacer()

                    Text(workout.startDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.appCaption)
                        .foregroundStyle(Color.appMutedForeground)
                }

                HStack(spacing: 16) {
                    Label("\(workout.duration) 分钟", systemImage: "clock")
                    Label(String(format: "%.0f kcal", workout.caloriesBurned), systemImage: "flame.fill")
                }
                .font(.appCaption)
                .foregroundStyle(Color.appMutedForeground)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("训练记录")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("完成") { dismiss() }
            }
        }
        .task {
            try? viewModel.loadRecentWorkouts()
        }
    }
}

struct RecentWorkoutRow: View {
    let workout: Workout

    private let categoryIcons: [String: String] = [
        "strength": "dumbbell.fill", "cardio": "figure.run", "flexibility": "figure.yoga",
        "sports": "basketball.fill", "water": "figure.pool.swim", "outdoor": "figure.hiking"
    ]

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: categoryIcons[workout.workoutCategory, default: "figure.run"])
                .foregroundStyle(Color.chartExercise)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(workout.exercises.map(\.exerciseName).joined(separator: "、"))
                    .font(.appCallout)
                    .foregroundStyle(Color.appForeground)
                    .lineLimit(1)

                HStack(spacing: 12) {
                    Text("\(workout.duration) 分钟")
                    Text(String(format: "%.0f kcal", workout.caloriesBurned))
                }
                .font(.appCaption)
                .foregroundStyle(Color.appMutedForeground)
            }

            Spacer()

            Text(workout.startDate.formatted(.relative(presentation: .named)))
                .font(.appCaption2)
                .foregroundStyle(Color.appMutedForeground)
        }
        .padding(12)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}