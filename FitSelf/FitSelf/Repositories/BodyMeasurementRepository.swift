import SwiftData
import Foundation

final class BodyMeasurementRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addMeasurement(weight: Double, bodyFatPercentage: Double? = nil, muscleMass: Double? = nil, waistCircumference: Double? = nil, recordedAt: Date = Date()) -> BodyMeasurement {
        let measurement = BodyMeasurement(
            weight: weight,
            bodyFatPercentage: bodyFatPercentage,
            muscleMass: muscleMass,
            waistCircumference: waistCircumference,
            recordedAt: recordedAt
        )
        modelContext.insert(measurement)
        return measurement
    }

    func latestMeasurement() throws -> BodyMeasurement? {
        var descriptor = FetchDescriptor<BodyMeasurement>()
        descriptor.sortBy = [SortDescriptor(\.recordedAt, order: .reverse)]
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    func measurements(from startDate: Date, to endDate: Date) throws -> [BodyMeasurement] {
        let descriptor = FetchDescriptor<BodyMeasurement>(
            predicate: #Predicate<BodyMeasurement> {
                $0.recordedAt >= startDate && $0.recordedAt <= endDate
            }
        )
        return try modelContext.fetch(descriptor)
    }

    func recentMeasurements(limit: Int = 30) throws -> [BodyMeasurement] {
        var descriptor = FetchDescriptor<BodyMeasurement>()
        descriptor.sortBy = [SortDescriptor(\.recordedAt, order: .reverse)]
        descriptor.fetchLimit = limit
        return try modelContext.fetch(descriptor)
    }

    func deleteMeasurement(_ measurement: BodyMeasurement) throws {
        modelContext.delete(measurement)
        try modelContext.save()
    }
}