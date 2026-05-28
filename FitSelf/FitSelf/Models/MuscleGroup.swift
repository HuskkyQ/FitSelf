import Foundation

enum IconType: Equatable {
    case sfSymbol(String)
    case abs
}

struct MuscleGroupData: Codable, Identifiable {
    let ppl: String
    let section: String
    let name: String
    let nameZh: String?
    let nameEn: String
    let abbr: String?
    let location: String?
    let note: String?
    let description: String?
    let functions: [String]?
    let primaryActions: [String]
    let subdivisions: [MuscleSubdivision]?
    let parentGroup: String?
    let weakPoint: Bool?
    let icon: String?

    var id: String { nameEn }

    var displayName: String {
        nameZh ?? name
    }
}

struct MuscleSubdivision: Codable {
    let name: String
    let location: String?
    let functions: [String]?
    let actions: [String]?
    let note: String?
    let weakPoint: Bool?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        functions = try container.decodeIfPresent([String].self, forKey: .functions)
        actions = try container.decodeIfPresent([String].self, forKey: .actions)
        note = try container.decodeIfPresent(String.self, forKey: .note)
        weakPoint = try container.decodeIfPresent(Bool.self, forKey: .weakPoint)
    }
}

struct MuscleHandbookPPL: Codable {
    let push: MuscleHandbookSection
    let pull: MuscleHandbookSection
    let legs: MuscleHandbookSection
}

struct MuscleHandbookSection: Codable {
    let name: String
    let muscles: [String]
}

struct MuscleWeakPoints: Codable {
    let name: String
    let description: String
    let items: [String]
}

struct MuscleHandbookRoot: Codable {
    let meta: MuscleHandbookMeta
    let pplClassification: MuscleHandbookPPL
    let weakPointMuscles: MuscleWeakPoints
    let muscleGroups: [MuscleGroupData]

    enum CodingKeys: String, CodingKey {
        case meta
        case pplClassification = "ppl_classification"
        case weakPointMuscles = "weak_point_muscles"
        case muscleGroups = "muscle_groups"
    }
}

struct MuscleHandbookMeta: Codable {
    let title: String
    let description: String
    let target: String
}

struct MuscleAbbreviationEntry: Codable {
    let en: String
    let zh: String
}