import SwiftData
import Foundation

struct EditSetDetail: Identifiable {
    let id = UUID()
    var weight: Double
    var reps: Int
    var rpe: Int?
}

@Observable
final class WorkoutViewModel {
    var activeWorkout: Workout?
    var exercises: [WorkoutExercise] = []
    var recentWorkouts: [Workout] = []
    var workoutCategory: String = "strength"

    var isWorkoutActive: Bool { activeWorkout != nil }
    var totalDuration: Int { activeWorkout?.duration ?? 0 }
    var totalCalories: Double { activeWorkout?.caloriesBurned ?? 0 }

    var workoutCategoryDisplayName: String {
        switch workoutCategory {
        case "strength": return "力量训练"
        case "cardio": return "有氧运动"
        case "flexibility": return "柔韧拉伸"
        case "sports": return "球类运动"
        case "water": return "水上运动"
        case "outdoor": return "户外运动"
        default: return "运动"
        }
    }

    private var workoutRepo: WorkoutRepository?

    func configure(context: ModelContext) {
        workoutRepo = WorkoutRepository(modelContext: context)
    }

    func startWorkout(category: String = "strength") {
        guard let repo = workoutRepo else { return }
        let workout = repo.createWorkout(category: category)
        activeWorkout = workout
        exercises = []
        workoutCategory = category
    }

    func addExercise(name: String, category: String = "strength", defaultSets: Int = 3, defaultReps: Int = 10) {
        guard let workout = activeWorkout, let repo = workoutRepo else { return }
        let exercise = repo.addExercise(to: workout, name: name, category: category)
        for _ in 1...defaultSets {
            _ = repo.addSet(to: exercise, weight: 0, reps: defaultReps, rpe: nil)
        }
        exercises.append(exercise)
    }

    func updateExerciseSets(exerciseIndex: Int, sets: [EditSetDetail]) {
        guard exerciseIndex < exercises.count, let repo = workoutRepo else { return }
        let exercise = exercises[exerciseIndex]
        for existingSet in exercise.sets {
            repo.deleteSet(existingSet)
        }
        for detail in sets {
            _ = repo.addSet(to: exercise, weight: detail.weight, reps: detail.reps, rpe: detail.rpe)
        }
    }

    func addSet(to exerciseIndex: Int, weight: Double = 0, reps: Int = 0, rpe: Int? = nil) {
        guard exerciseIndex < exercises.count, let repo = workoutRepo else { return }
        let exercise = exercises[exerciseIndex]
        let set = repo.addSet(to: exercise, weight: weight, reps: reps, rpe: rpe)
    }

    func updateSet(exerciseIndex: Int, setIndex: Int, weight: Double, reps: Int, rpe: Int?) {
        guard exerciseIndex < exercises.count else { return }
        let exercise = exercises[exerciseIndex]
        let sortedSets = exercise.sets.sorted { $0.setNumber < $1.setNumber }
        guard setIndex < sortedSets.count else { return }
        let set = sortedSets[setIndex]
        set.weight = weight
        set.reps = reps
        set.rpe = rpe
        set.isCompleted = true
    }

    func completeSet(exerciseIndex: Int, setIndex: Int, weight: Double, reps: Int, rpe: Int? = nil) {
        guard exerciseIndex < exercises.count, setIndex < exercises[exerciseIndex].sets.count else { return }
        let set = exercises[exerciseIndex].sets[setIndex]
        set.weight = weight
        set.reps = reps
        set.rpe = rpe
        set.isCompleted = true
    }

    func finishWorkout() throws {
        guard let workout = activeWorkout, let repo = workoutRepo else { return }
        workout.endDate = Date()
        workout.duration = Int(workout.endDate.timeIntervalSince(workout.startDate) / 60)

        let totalVolume = exercises.reduce(0.0) { $0 + $1.totalVolume }
        workout.caloriesBurned = estimateCalories(duration: workout.duration, volume: totalVolume)

        try repo.save()
        activeWorkout = nil
        exercises = []
    }

    func cancelWorkout() {
        guard let workout = activeWorkout, let repo = workoutRepo else { return }
        repo.delete(workout)
        activeWorkout = nil
        exercises = []
    }

    func loadRecentWorkouts() throws {
        guard let repo = workoutRepo else { return }
        recentWorkouts = try repo.recentWorkouts()
    }

    private func estimateCalories(duration: Int, volume: Double) -> Double {
        let baseCalories = Double(duration) * 5.0
        let volumeCalories = volume / 1000.0
        return baseCalories + volumeCalories
    }
}