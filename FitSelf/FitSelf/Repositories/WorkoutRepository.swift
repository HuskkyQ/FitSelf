import SwiftData
import Foundation

final class WorkoutRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func createWorkout(category: String, startDate: Date = Date()) -> Workout {
        let workout = Workout(workoutCategory: category, startDate: startDate)
        modelContext.insert(workout)
        return workout
    }

    func addExercise(to workout: Workout, name: String, category: String = "strength") -> WorkoutExercise {
        let exercise = WorkoutExercise(exerciseName: name, exerciseCategory: category)
        exercise.workout = workout
        modelContext.insert(exercise)
        return exercise
    }

    func addSet(to exercise: WorkoutExercise, weight: Double = 0, reps: Int = 0, rpe: Int? = nil, restInterval: Int? = 90) -> WorkoutSet {
        let setNumber = exercise.sets.count + 1
        let set = WorkoutSet(setNumber: setNumber, weight: weight, reps: reps, restInterval: restInterval, rpe: rpe)
        set.exercise = exercise
        modelContext.insert(set)
        return set
    }

    func workouts(for date: Date) throws -> [Workout] {
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        var descriptor = FetchDescriptor<Workout>(
            predicate: #Predicate<Workout> {
                $0.startDate >= start && $0.startDate < end
            }
        )
        descriptor.sortBy = [SortDescriptor(\.startDate, order: .reverse)]
        return try modelContext.fetch(descriptor)
    }

    func totalExerciseDuration(in date: Date) throws -> Int {
        let workouts = try self.workouts(for: date)
        return workouts.reduce(0) { $0 + $1.duration }
    }

    func recentWorkouts(limit: Int = 10) throws -> [Workout] {
        var descriptor = FetchDescriptor<Workout>()
        descriptor.sortBy = [SortDescriptor(\.startDate, order: .reverse)]
        descriptor.fetchLimit = limit
        return try modelContext.fetch(descriptor)
    }

    func save() throws {
        try modelContext.save()
    }

    func delete(_ workout: Workout) {
        modelContext.delete(workout)
    }

    func deleteSet(_ set: WorkoutSet) {
        modelContext.delete(set)
    }
}