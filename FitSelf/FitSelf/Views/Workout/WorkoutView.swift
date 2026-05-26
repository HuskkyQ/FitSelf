import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = WorkoutViewModel()
    @State private var showingExercisePicker = false
    @State private var showingCustomExercise = false
    @State private var showingWorkoutHistory = false
    @State private var expandedExerciseIds: Set<PersistentIdentifier> = []

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
                            } catch {
                                // TODO: 错误处理
                            }
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
                ExercisePickerView(viewModel: viewModel, category: viewModel.workoutCategory)
            }
            .sheet(isPresented: $showingCustomExercise) {
                CustomExerciseView(viewModel: viewModel, category: viewModel.workoutCategory)
            }
            .sheet(isPresented: $showingWorkoutHistory) {
                NavigationStack {
                    WorkoutHistoryView(viewModel: viewModel)
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

                exerciseListSection

                addExerciseButton

                if !viewModel.exercises.isEmpty {
                    workoutSummarySection
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
        .overlay(alignment: .bottom) {
            workoutBottomBar
        }
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
                ExerciseRowView(
                    exercise: exercise,
                    isExpanded: expandedExerciseIds.contains(exercise.id),
                    onToggle: { toggleExercise(exercise.id) },
                    onAddSet: { addSet(for: index) },
                    onUpdateSet: { setIndex, weight, reps, rpe in
                        viewModel.updateSet(exerciseIndex: index, setIndex: setIndex, weight: weight, reps: reps, rpe: rpe)
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
            .foregroundStyle(Color.appDestructive)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button("完成训练") {
                do {
                    try viewModel.finishWorkout()
                } catch {
                    // TODO: 错误处理
                }
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
        .background(Color.appBackground)
    }

    private func toggleExercise(_ id: PersistentIdentifier) {
        if expandedExerciseIds.contains(id) {
            expandedExerciseIds.remove(id)
        } else {
            expandedExerciseIds.insert(id)
        }
    }

    private func addSet(for index: Int) {
        viewModel.addSet(to: index)
    }
}

struct ExerciseRowView: View {
    let exercise: WorkoutExercise
    let isExpanded: Bool
    let onToggle: () -> Void
    let onAddSet: () -> Void
    let onUpdateSet: (Int, Double, Int, Int?) -> Void

    @State private var setInputs: [SetInput] = []

    struct SetInput {
        var weight: String = ""
        var reps: String = ""
        var rpe: Int? = nil
    }

    var body: some View {
        VStack(spacing: 0) {
            Button { onToggle() } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(exercise.exerciseName)
                            .font(.appCallout)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.appForeground)

                        HStack(spacing: 8) {
                            Text("\(exercise.sets.count) 组")
                            if exercise.totalVolume > 0 {
                                Text("·")
                                Text(String(format: "%.1f kg", exercise.totalVolume))
                            }
                        }
                        .font(.appCaption)
                        .foregroundStyle(Color.appMutedForeground)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(Color.appMutedForeground)
                        .font(.caption)
                }
                .padding(12)
            }

            if isExpanded {
                Divider().padding(.horizontal, 12)

                setsInputTable

                Button {
                    onAddSet()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("添加一组")
                    }
                    .font(.appFootnote)
                    .foregroundStyle(Color.appPrimary)
                    .padding(.vertical, 8)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
            }
        }
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onChange(of: exercise.sets.count) { _, _ in
            syncSetInputs()
        }
        .onAppear {
            syncSetInputs()
        }
    }

    private var sortedSets: [WorkoutSet] {
        exercise.sets.sorted { $0.setNumber < $1.setNumber }
    }

    private func syncSetInputs() {
        let sets = sortedSets
        let newInputs = sets.map { set -> SetInput in
            if set.isCompleted {
                return SetInput(weight: String(format: "%.1f", set.weight), reps: "\(set.reps)", rpe: set.rpe)
            } else {
                return SetInput(weight: "", reps: "", rpe: nil)
            }
        }
        setInputs = newInputs
    }

    private var setsInputTable: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("#").frame(width: 28)
                Text("重量").frame(width: 60)
                Text("次数").frame(width: 50)
                Text("RPE").frame(width: 50)
                Spacer().frame(width: 28)
            }
            .font(.appCaption2)
            .foregroundStyle(Color.appMutedForeground)
            .padding(.vertical, 6)

            ForEach(Array(sortedSets.enumerated()), id: \.element.id) { index, set in
                HStack(spacing: 0) {
                    Text("\(set.setNumber)")
                        .frame(width: 28)
                        .font(.appCaption)
                        .foregroundStyle(Color.appMutedForeground)

                    TextField("0", text: Binding(
                        get: { index < setInputs.count ? setInputs[index].weight : "" },
                        set: { if index < setInputs.count { setInputs[index].weight = $0 } }
                    ))
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 60)
                    .font(.appCaption)

                    TextField("0", text: Binding(
                        get: { index < setInputs.count ? setInputs[index].reps : "" },
                        set: { if index < setInputs.count { setInputs[index].reps = $0 } }
                    ))
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 50)
                    .font(.appCaption)

                    TextField("0", text: Binding(
                        get: { if index < setInputs.count, let rpe = setInputs[index].rpe { "\(rpe)" } else { "" } },
                        set: { if index < setInputs.count { setInputs[index].rpe = Int($0) } }
                    ))
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 50)
                    .font(.appCaption)

                    Spacer().frame(width: 28)
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.horizontal, 12)
    }
}

struct ExercisePickerView: View {
    let viewModel: WorkoutViewModel
    let category: String
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                let types = WorkoutTypeStore.types(for: category)
                let filtered = searchText.isEmpty ? types : types.filter { $0.name.contains(searchText) }

                ForEach(filtered) { type in
                    Button {
                        viewModel.addExercise(name: type.name, category: type.category)
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button("取消") { dismiss() }
                }
            }
            .searchable(text: $searchText, prompt: "搜索动作")
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

    var body: some View {
        NavigationStack {
            Form {
                Section("自定义动作") {
                    TextField("动作名称", text: $exerciseName)
                }
            }
            .navigationTitle("添加自定义动作")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("添加") {
                        guard !exerciseName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        viewModel.addExercise(name: exerciseName.trimmingCharacters(in: .whitespaces), category: category)
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