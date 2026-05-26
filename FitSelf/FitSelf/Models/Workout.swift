import SwiftData
import Foundation

@Model
final class Workout {
    var workoutCategory: String
    var startDate: Date
    var endDate: Date
    var duration: Int
    var distance: Double?
    var caloriesBurned: Double
    var averageHeartRate: Double?
    var notes: String?
    var source: String
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \WorkoutExercise.workout)
    var exercises: [WorkoutExercise] = []

    var workoutType: String {
        exercises.first?.exerciseName ?? ""
    }

    init(workoutCategory: String = "strength",
         startDate: Date = Date(),
         endDate: Date = Date(),
         duration: Int = 0,
         distance: Double? = nil,
         caloriesBurned: Double = 0,
         averageHeartRate: Double? = nil,
         notes: String? = nil,
         source: String = "manual") {
        self.workoutCategory = workoutCategory
        self.startDate = startDate
        self.endDate = endDate
        self.duration = duration
        self.distance = distance
        self.caloriesBurned = caloriesBurned
        self.averageHeartRate = averageHeartRate
        self.notes = notes
        self.source = source
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

@Model
final class WorkoutExercise {
    var exerciseName: String
    var exerciseCategory: String
    var isFavorite: Bool
    var sortOrder: Int
    var createdAt: Date

    var workout: Workout?
    var sets: [WorkoutSet] = []

    init(exerciseName: String,
         exerciseCategory: String = "strength",
         isFavorite: Bool = false,
         sortOrder: Int = 0) {
        self.exerciseName = exerciseName
        self.exerciseCategory = exerciseCategory
        self.isFavorite = isFavorite
        self.sortOrder = sortOrder
        self.createdAt = Date()
    }

    var totalVolume: Double {
        sets.filter { $0.isCompleted }.reduce(0) { $0 + ($1.weight * Double($1.reps)) }
    }
}

@Model
final class WorkoutSet {
    var setNumber: Int
    var weight: Double
    var reps: Int
    var restInterval: Int?
    var rpe: Int?
    var isCompleted: Bool
    var createdAt: Date

    var exercise: WorkoutExercise?

    init(setNumber: Int,
         weight: Double = 0,
         reps: Int = 0,
         restInterval: Int? = 90,
         rpe: Int? = nil,
         isCompleted: Bool = false) {
        self.setNumber = setNumber
        self.weight = weight
        self.reps = reps
        self.restInterval = restInterval
        self.rpe = rpe
        self.isCompleted = isCompleted
        self.createdAt = Date()
    }
}