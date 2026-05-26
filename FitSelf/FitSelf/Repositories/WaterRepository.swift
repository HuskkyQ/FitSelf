import SwiftData
import Foundation

final class WaterRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addWater(milliliters: Int, recordedAt: Date = Date()) -> WaterEntry {
        let entry = WaterEntry(milliliters: milliliters, recordedAt: recordedAt)
        modelContext.insert(entry)
        return entry
    }

    func totalWater(for date: Date) throws -> Int {
        let entries = try waterEntries(for: date)
        return entries.reduce(0) { $0 + $1.milliliters }
    }

    func waterEntries(for date: Date) throws -> [WaterEntry] {
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        let descriptor = FetchDescriptor<WaterEntry>(
            predicate: #Predicate<WaterEntry> {
                $0.recordedAt >= start && $0.recordedAt < end
            }
        )
        return try modelContext.fetch(descriptor)
    }

    func deleteEntry(_ entry: WaterEntry) throws {
        modelContext.delete(entry)
        try modelContext.save()
    }
}