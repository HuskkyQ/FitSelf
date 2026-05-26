import SwiftData
import Foundation

@Observable
final class WorkoutViewModel {
    var activeWorkout: Workout?
    var exercises: [WorkoutExercise] = []
    var recentWorkouts: [Workout] = []

    var isWorkoutActive: Bool { activeWorkout != nil }
    var totalDuration: Int { activeWorkout?.duration ?? 0 }
    var totalCalories: Double { activeWorkout?.caloriesBurned ?? 0 }

    private var workoutRepo: WorkoutRepository?

    func configure(context: ModelContext) {
        workoutRepo = WorkoutRepository(modelContext: context)
    }

    func startWorkout(category: String = "strength") {
        guard let repo = workoutRepo else { return }
        let workout = repo.createWorkout(category: category)
        activeWorkout = workout
        exercises = []
    }

    func addExercise(name: String, category: String = "strength") {
        guard let workout = activeWorkout, let repo = workoutRepo else { return }
        let exercise = repo.addExercise(to: workout, name: name, category: category)
        exercises.append(exercise)
    }

    func addSet(to exerciseIndex: Int, weight: Double = 0, reps: Int = 0, rpe: Int? = nil) {
        guard exerciseIndex < exercises.count, let repo = workoutRepo else { return }
        let exercise = exercises[exerciseIndex]
        let set = repo.addSet(to: exercise, weight: weight, reps: reps, rpe: rpe)
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