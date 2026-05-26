import SwiftData
import Foundation

final class UserProfileRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func ensureProfile() throws -> UserProfile {
        let descriptor = FetchDescriptor<UserProfile>()
        let profiles = try modelContext.fetch(descriptor)
        if let profile = profiles.first {
            return profile
        }
        let profile = UserProfile()
        modelContext.insert(profile)
        try modelContext.save()
        return profile
    }

    func updateProfile(_ transform: (UserProfile) throws -> Void) throws -> UserProfile {
        let profile = try ensureProfile()
        try transform(profile)
        profile.updatedAt = Date()
        try modelContext.save()
        return profile
    }
}