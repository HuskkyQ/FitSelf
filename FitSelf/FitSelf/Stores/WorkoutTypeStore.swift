import Foundation

struct WorkoutType: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: String
    let metValue: Double
    let icon: String

    func caloriesPerMinute(weightKg: Double) -> Double {
        metValue * 3.5 * weightKg / 200.0
    }
}

enum WorkoutTypeStore {
    static let categories: [(String, String)] = [
        ("strength", "力量训练"),
        ("cardio", "有氧运动"),
        ("flexibility", "柔韧拉伸"),
        ("sports", "球类运动"),
        ("water", "水上运动"),
        ("outdoor", "户外运动"),
        ("other", "其他")
    ]

    static let types: [WorkoutType] = [
        // 力量训练
        WorkoutType(name: "杠铃深蹲", category: "strength", metValue: 6.0, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "杠铃卧推", category: "strength", metValue: 6.0, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "杠铃硬拉", category: "strength", metValue: 6.0, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "杠铃划船", category: "strength", metValue: 5.0, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "杠铃推举", category: "strength", metValue: 5.0, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "引体向上", category: "strength", metValue: 8.0, icon: "figure.strengthtraining.functional"),
        WorkoutType(name: "俯卧撑", category: "strength", metValue: 8.0, icon: "figure.strengthtraining.functional"),
        WorkoutType(name: "哑铃弯举", category: "strength", metValue: 4.0, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "哑铃飞鸟", category: "strength", metValue: 4.0, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "哑铃侧平举", category: "strength", metValue: 4.0, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "腿举", category: "strength", metValue: 5.0, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "腿弯举", category: "strength", metValue: 4.5, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "小腿提踵", category: "strength", metValue: 4.0, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "腹肌卷腹", category: "strength", metValue: 5.0, icon: "figure.strengthtraining.functional"),
        WorkoutType(name: "平板支撑", category: "strength", metValue: 4.0, icon: "figure.strengthtraining.functional"),
        WorkoutType(name: "臀桥", category: "strength", metValue: 4.0, icon: "figure.strengthtraining.functional"),
        WorkoutType(name: "哑铃深蹲", category: "strength", metValue: 5.5, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "拉力器夹胸", category: "strength", metValue: 4.5, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "坐姿划船", category: "strength", metValue: 5.0, icon: "figure.strengthtraining.traditional"),
        WorkoutType(name: "三头下压", category: "strength", metValue: 4.0, icon: "figure.strengthtraining.traditional"),

        // 有氧运动
        WorkoutType(name: "跑步", category: "cardio", metValue: 9.8, icon: "figure.run"),
        WorkoutType(name: "慢跑", category: "cardio", metValue: 7.0, icon: "figure.run"),
        WorkoutType(name: "快走", category: "cardio", metValue: 4.3, icon: "figure.walk"),
        WorkoutType(name: "骑自行车", category: "cardio", metValue: 8.0, icon: "figure.outdoor.cycle"),
        WorkoutType(name: "室内动感单车", category: "cardio", metValue: 10.0, icon: "figure.indoor.cycle"),
        WorkoutType(name: "跳绳", category: "cardio", metValue: 12.3, icon: "figure.jumprope"),
        WorkoutType(name: "划船机", category: "cardio", metValue: 7.0, icon: "figure.rowing"),
        WorkoutType(name: "椭圆机", category: "cardio", metValue: 5.0, icon: "figure.indoor.cycle"),
        WorkoutType(name: "爬楼梯", category: "cardio", metValue: 9.0, icon: "figure.stairs"),
        WorkoutType(name: "HIIT训练", category: "cardio", metValue: 12.0, icon: "figure.highintensity.intervaltraining"),
        WorkoutType(name: "踏步机", category: "cardio", metValue: 5.0, icon: "figure.stairs"),

        // 柔韧拉伸
        WorkoutType(name: "瑜伽", category: "flexibility", metValue: 3.0, icon: "figure.yoga"),
        WorkoutType(name: "普拉提", category: "flexibility", metValue: 5.0, icon: "figure.yoga"),
        WorkoutType(name: "拉伸", category: "flexibility", metValue: 2.5, icon: "figure.flexibility"),
        WorkoutType(name: "太极", category: "flexibility", metValue: 3.0, icon: "figure.yoga"),
        WorkoutType(name: "泡沫轴放松", category: "flexibility", metValue: 2.5, icon: "figure.flexibility"),

        // 球类运动
        WorkoutType(name: "篮球", category: "sports", metValue: 8.0, icon: "figure.basketball"),
        WorkoutType(name: "足球", category: "sports", metValue: 10.0, icon: "figure.soccer"),
        WorkoutType(name: "羽毛球", category: "sports", metValue: 7.0, icon: "figure.badminton"),
        WorkoutType(name: "乒乓球", category: "sports", metValue: 4.0, icon: "figure.table.tennis"),
        WorkoutType(name: "网球", category: "sports", metValue: 7.3, icon: "figure.tennis"),
        WorkoutType(name: "排球", category: "sports", metValue: 6.0, icon: "figure.volleyball"),
        WorkoutType(name: "高尔夫", category: "sports", metValue: 4.8, icon: "figure.golf"),

        // 水上运动
        WorkoutType(name: "自由泳", category: "water", metValue: 8.0, icon: "figure.pool.swim"),
        WorkoutType(name: "蛙泳", category: "water", metValue: 6.0, icon: "figure.pool.swim"),
        WorkoutType(name: "蝶泳", category: "water", metValue: 11.0, icon: "figure.pool.swim"),
        WorkoutType(name: "水中有氧", category: "water", metValue: 5.5, icon: "figure.pool.swim"),
        WorkoutType(name: "冲浪", category: "water", metValue: 5.0, icon: "figure.surfing"),

        // 户外运动
        WorkoutType(name: "登山", category: "outdoor", metValue: 6.5, icon: "figure.hiking"),
        WorkoutType(name: "徒步", category: "outdoor", metValue: 5.3, icon: "figure.hiking"),
        WorkoutType(name: "攀岩", category: "outdoor", metValue: 8.0, icon: "figure.climbing"),
        WorkoutType(name: "滑雪", category: "outdoor", metValue: 7.0, icon: "figure.snowboarding"),
        WorkoutType(name: "滑板", category: "outdoor", metValue: 5.0, icon: "figure.skating"),
    ]

    static func types(for category: String) -> [WorkoutType] {
        types.filter { $0.category == category }
    }

    static func search(query: String) -> [WorkoutType] {
        guard !query.isEmpty else { return types }
        return types.filter { $0.name.contains(query) }
    }
}