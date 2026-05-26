import SwiftData
import Foundation

@Model
final class BodyMeasurement {
    var weight: Double
    var bodyFatPercentage: Double?
    var muscleMass: Double?
    var waistCircumference: Double?
    var recordedAt: Date
    var createdAt: Date

    init(weight: Double,
         bodyFatPercentage: Double? = nil,
         muscleMass: Double? = nil,
         waistCircumference: Double? = nil,
         recordedAt: Date = Date()) {
        self.weight = weight
        self.bodyFatPercentage = bodyFatPercentage
        self.muscleMass = muscleMass
        self.waistCircumference = waistCircumference
        self.recordedAt = recordedAt
        self.createdAt = Date()
    }
}

@Model
final class WaterEntry {
    var milliliters: Int
    var recordedAt: Date
    var createdAt: Date

    init(milliliters: Int, recordedAt: Date = Date()) {
        self.milliliters = milliliters
        self.recordedAt = recordedAt
        self.createdAt = Date()
    }
}