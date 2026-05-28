import Foundation

enum MuscleGroupStore {
    static func load() -> [MuscleGroupData] {
        guard let url = Bundle.main.url(forResource: "muscle_groups", withExtension: "json") else {
            print("⚠️ muscle_groups.json not found in bundle")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let root = try JSONDecoder().decode(MuscleHandbookRoot.self, from: data)
            return root.muscleGroups
        } catch {
            print("⚠️ Failed to parse muscle_groups.json: \(error)")
            return []
        }
    }

    static let groupedBySection: [(section: String, title: String, icon: String, iconType: IconType, color: String, muscles: [MuscleGroupData])] = {
        let all = load()

        let sectionOrder: [(key: String, ppl: String, title: String, iconType: IconType, color: String)] = [
            (key: "上肢推肌群", ppl: "push", title: "推 Push", iconType: .sfSymbol("dumbbell.fill"), color: "F97316"),
            (key: "上肢拉肌群", ppl: "pull", title: "拉 Pull", iconType: .sfSymbol("figure.climbing"), color: "8B5CF6"),
            (key: "下肢肌群",   ppl: "legs", title: "腿 Legs", iconType: .sfSymbol("figure.strengthtraining.functional"), color: "22C55E"),
            (key: "核心肌群",   ppl: "core", title: "核心 Core", iconType: .abs, color: "3B82F6"),
        ]

        var result: [(section: String, title: String, icon: String, iconType: IconType, color: String, muscles: [MuscleGroupData])] = []

        let coveredKeys = Set(sectionOrder.map { $0.key })

        for item in sectionOrder {
            let muscles = all.filter { $0.section == item.key }
            result.append((section: item.key, title: item.title, icon: "", iconType: item.iconType, color: item.color, muscles: muscles))
        }

        let remaining = all.filter { !coveredKeys.contains($0.section) }
        if !remaining.isEmpty {
            result.append((section: "其他", title: "其他", icon: "", iconType: .sfSymbol("figure.run"), color: "737373", muscles: remaining))
        }

        return result
    }()

    static let weakPoints: [String] = {
        guard let url = Bundle.main.url(forResource: "muscle_groups", withExtension: "json") else { return [] }
        do {
            let data = try Data(contentsOf: url)
            let root = try JSONDecoder().decode(MuscleHandbookRoot.self, from: data)
            return root.weakPointMuscles.items
        } catch {
            return []
        }
    }()

    static let pplClassification: MuscleHandbookPPL? = {
        guard let url = Bundle.main.url(forResource: "muscle_groups", withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let root = try JSONDecoder().decode(MuscleHandbookRoot.self, from: data)
            return root.pplClassification
        } catch {
            return nil
        }
    }()
}