import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = WorkoutViewModel()
    @State private var showingExercisePicker = false
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
            .navigationTitle("运动")
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
                ExercisePickerView(viewModel: viewModel)
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
                    workoutCategoryButton(title: "力量训练", icon: "dumbbell.fill", category: "strength", color: .chartExercise)
                    workoutCategoryButton(title: "有氧运动", icon: "figure.run", category: "cardio", color: .chartCalories)
                    workoutCategoryButton(title: "柔韧拉伸", icon: "figure.yoga", category: "flexibility", color: .chartProtein)
                    workoutCategoryButton(title: "球类运动", icon: "basketball.fill", category: "sports", color: .chartCarbs)
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
                    onAddSet: { addSet(for: index) }
                )
            }
        }
    }

    private var addExerciseButton: some View {
        Button {
            showingExercisePicker = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("添加动作")
            }
            .font(.appCallout)
            .foregroundStyle(Color.appPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.appPrimary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
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

                setsTableView

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
    }

    private var setsTableView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("#").frame(width: 32)
                Text("上次").frame(width: 56)
                Text("重量").frame(width: 56)
                Text("次数").frame(width: 56)
                Text("RPE").frame(width: 40)
                Spacer().frame(width: 32)
            }
            .font(.appCaption2)
            .foregroundStyle(Color.appMutedForeground)
            .padding(.vertical, 6)

            ForEach(Array(exercise.sets.sorted { $0.setNumber < $1.setNumber }.enumerated()), id: \.element.id) { _, set in
                HStack(spacing: 0) {
                    Text("\(set.setNumber)")
                        .frame(width: 32)
                        .foregroundStyle(Color.appMutedForeground)

                    Text(set.isCompleted ? "\(Int(set.weight))×\(set.reps)" : "—")
                        .frame(width: 56)
                        .foregroundStyle(Color.appMutedForeground)

                    Text(set.isCompleted ? String(format: "%.1f", set.weight) : "")
                        .frame(width: 56)
                        .foregroundStyle(Color.appForeground)

                    Text(set.isCompleted ? "\(set.reps)" : "")
                        .frame(width: 56)
                        .foregroundStyle(Color.appForeground)

                    if let rpe = set.rpe {
                        HStack(spacing: 2) {
                            ForEach(1...10, id: \.self) { i in
                                Circle()
                                    .fill(i <= rpe ? Color.appPrimary : Color.appMuted.opacity(0.3))
                                    .frame(width: 4, height: 4)
                            }
                        }
                        .frame(width: 40)
                    } else {
                        Text("—").frame(width: 40)
                            .foregroundStyle(Color.appMutedForeground)
                    }

                    Spacer().frame(width: 32)
                }
                .font(.appFootnote)
                .padding(.vertical, 6)
            }
        }
        .padding(.horizontal, 12)
    }
}

struct ExercisePickerView: View {
    let viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedCategory = "strength"

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("类别", selection: $selectedCategory) {
                    ForEach(WorkoutTypeStore.categories, id: \.0) { value, label in
                        Text(label).tag(value)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

                List {
                    ForEach(filteredTypes) { type in
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
            }
            .navigationTitle("选择动作")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("取消") { dismiss() }
                }
            }
            .searchable(text: $searchText, prompt: "搜索动作")
        }
    }

    private var filteredTypes: [WorkoutType] {
        let types = WorkoutTypeStore.types(for: selectedCategory)
        if searchText.isEmpty {
            return types
        }
        return types.filter { $0.name.contains(searchText) }
    }
}

struct WorkoutHistoryView: View {
    let viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List(viewModel.recentWorkouts) { workout in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(workout.workoutCategory == "strength" ? "力量训练" : "运动")
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

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: workout.workoutCategory == "strength" ? "dumbbell.fill" : "figure.run")
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