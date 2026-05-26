import SwiftData
import Foundation

struct FoodSeedItem {
    let name: String
    let caloriesPer100g: Double
    let proteinPer100g: Double
    let fatPer100g: Double
    let carbsPer100g: Double
    let category: String
}

enum FoodDatabaseSeeder {
    static let commonFoods: [FoodSeedItem] = [
        FoodSeedItem(name: "白米饭", caloriesPer100g: 116, proteinPer100g: 2.6, fatPer100g: 0.3, carbsPer100g: 25.9, category: "主食"),
        FoodSeedItem(name: "面条(煮)", caloriesPer100g: 110, proteinPer100g: 3.4, fatPer100g: 0.6, carbsPer100g: 23.0, category: "主食"),
        FoodSeedItem(name: "馒头", caloriesPer100g: 221, proteinPer100g: 7.0, fatPer100g: 1.1, carbsPer100g: 47.0, category: "主食"),
        FoodSeedItem(name: "全麦面包", caloriesPer100g: 246, proteinPer100g: 8.5, fatPer100g: 3.5, carbsPer100g: 44.3, category: "主食"),
        FoodSeedItem(name: "燕麦片", caloriesPer100g: 367, proteinPer100g: 15.0, fatPer100g: 6.7, carbsPer100g: 61.6, category: "主食"),
        FoodSeedItem(name: "红薯", caloriesPer100g: 86, proteinPer100g: 1.6, fatPer100g: 0.1, carbsPer100g: 20.1, category: "主食"),
        FoodSeedItem(name: "玉米", caloriesPer100g: 112, proteinPer100g: 4.0, fatPer100g: 1.2, carbsPer100g: 22.8, category: "主食"),
        FoodSeedItem(name: "土豆", caloriesPer100g: 76, proteinPer100g: 2.0, fatPer100g: 0.2, carbsPer100g: 16.5, category: "主食"),

        FoodSeedItem(name: "鸡胸肉", caloriesPer100g: 133, proteinPer100g: 31.0, fatPer100g: 1.2, carbsPer100g: 0, category: "肉蛋"),
        FoodSeedItem(name: "鸡腿肉", caloriesPer100g: 181, proteinPer100g: 22.0, fatPer100g: 9.0, carbsPer100g: 0, category: "肉蛋"),
        FoodSeedItem(name: "猪瘦肉", caloriesPer100g: 143, proteinPer100g: 20.3, fatPer100g: 6.2, carbsPer100g: 1.5, category: "肉蛋"),
        FoodSeedItem(name: "牛肉(瘦)", caloriesPer100g: 125, proteinPer100g: 19.9, fatPer100g: 4.2, carbsPer100g: 2.0, category: "肉蛋"),
        FoodSeedItem(name: "三文鱼", caloriesPer100g: 139, proteinPer100g: 21.6, fatPer100g: 5.9, carbsPer100g: 0, category: "肉蛋"),
        FoodSeedItem(name: "虾仁", caloriesPer100g: 87, proteinPer100g: 18.6, fatPer100g: 0.8, carbsPer100g: 1.0, category: "肉蛋"),
        FoodSeedItem(name: "鸡蛋(煮)", caloriesPer100g: 144, proteinPer100g: 13.3, fatPer100g: 10.0, carbsPer100g: 1.5, category: "肉蛋"),
        FoodSeedItem(name: "鸡翅", caloriesPer100g: 194, proteinPer100g: 17.4, fatPer100g: 13.5, carbsPer100g: 0, category: "肉蛋"),
        FoodSeedItem(name: "猪肝", caloriesPer100g: 129, proteinPer100g: 21.3, fatPer100g: 3.5, carbsPer100g: 4.2, category: "肉蛋"),

        FoodSeedItem(name: "牛奶", caloriesPer100g: 54, proteinPer100g: 3.0, fatPer100g: 3.2, carbsPer100g: 3.4, category: "乳制品"),
        FoodSeedItem(name: "酸奶(原味)", caloriesPer100g: 72, proteinPer100g: 3.5, fatPer100g: 2.5, carbsPer100g: 8.0, category: "乳制品"),
        FoodSeedItem(name: "奶酪", caloriesPer100g: 328, proteinPer100g: 20.0, fatPer100g: 25.0, carbsPer100g: 4.0, category: "乳制品"),

        FoodSeedItem(name: "西兰花", caloriesPer100g: 34, proteinPer100g: 4.1, fatPer100g: 0.6, carbsPer100g: 4.3, category: "蔬菜"),
        FoodSeedItem(name: "菠菜", caloriesPer100g: 24, proteinPer100g: 2.6, fatPer100g: 0.3, carbsPer100g: 3.6, category: "蔬菜"),
        FoodSeedItem(name: "番茄", caloriesPer100g: 19, proteinPer100g: 0.9, fatPer100g: 0.2, carbsPer100g: 3.5, category: "蔬菜"),
        FoodSeedItem(name: "黄瓜", caloriesPer100g: 15, proteinPer100g: 0.7, fatPer100g: 0.2, carbsPer100g: 2.9, category: "蔬菜"),
        FoodSeedItem(name: "胡萝卜", caloriesPer100g: 37, proteinPer100g: 0.9, fatPer100g: 0.2, carbsPer100g: 8.1, category: "蔬菜"),
        FoodSeedItem(name: "生菜", caloriesPer100g: 13, proteinPer100g: 1.3, fatPer100g: 0.3, carbsPer100g: 1.3, category: "蔬菜"),
        FoodSeedItem(name: "茄子", caloriesPer100g: 21, proteinPer100g: 1.1, fatPer100g: 0.2, carbsPer100g: 4.6, category: "蔬菜"),
        FoodSeedItem(name: "青椒", caloriesPer100g: 22, proteinPer100g: 1.0, fatPer100g: 0.2, carbsPer100g: 4.2, category: "蔬菜"),

        FoodSeedItem(name: "苹果", caloriesPer100g: 52, proteinPer100g: 0.3, fatPer100g: 0.2, carbsPer100g: 13.5, category: "水果"),
        FoodSeedItem(name: "香蕉", caloriesPer100g: 89, proteinPer100g: 1.1, fatPer100g: 0.3, carbsPer100g: 22.8, category: "水果"),
        FoodSeedItem(name: "橙子", caloriesPer100g: 47, proteinPer100g: 0.9, fatPer100g: 0.1, carbsPer100g: 11.1, category: "水果"),
        FoodSeedItem(name: "葡萄", caloriesPer100g: 69, proteinPer100g: 0.7, fatPer100g: 0.3, carbsPer100g: 17.2, category: "水果"),
        FoodSeedItem(name: "西瓜", caloriesPer100g: 30, proteinPer100g: 0.6, fatPer100g: 0.1, carbsPer100g: 7.6, category: "水果"),
        FoodSeedItem(name: "草莓", caloriesPer100g: 32, proteinPer100g: 1.0, fatPer100g: 0.3, carbsPer100g: 7.1, category: "水果"),
        FoodSeedItem(name: "梨", caloriesPer100g: 57, proteinPer100g: 0.4, fatPer100g: 0.1, carbsPer100g: 13.7, category: "水果"),

        FoodSeedItem(name: "豆腐", caloriesPer100g: 73, proteinPer100g: 8.1, fatPer100g: 3.7, carbsPer100g: 2.8, category: "豆制品"),
        FoodSeedItem(name: "豆浆(无糖)", caloriesPer100g: 31, proteinPer100g: 3.0, fatPer100g: 1.6, carbsPer100g: 1.2, category: "豆制品"),
        FoodSeedItem(name: "毛豆", caloriesPer100g: 131, proteinPer100g: 13.0, fatPer100g: 5.8, carbsPer100g: 7.3, category: "豆制品"),

        FoodSeedItem(name: "花生", caloriesPer100g: 563, proteinPer100g: 24.8, fatPer100g: 44.3, carbsPer100g: 21.7, category: "坚果"),
        FoodSeedItem(name: "核桃", caloriesPer100g: 654, proteinPer100g: 15.0, fatPer100g: 65.2, carbsPer100g: 13.7, category: "坚果"),
        FoodSeedItem(name: "杏仁", caloriesPer100g: 578, proteinPer100g: 21.2, fatPer100g: 49.4, carbsPer100g: 21.7, category: "坚果"),

        FoodSeedItem(name: "可乐", caloriesPer100g: 43, proteinPer100g: 0, fatPer100g: 0, carbsPer100g: 10.6, category: "饮品"),
        FoodSeedItem(name: "美式咖啡(黑)", caloriesPer100g: 2, proteinPer100g: 0.3, fatPer100g: 0, carbsPer100g: 0, category: "饮品"),
        FoodSeedItem(name: "拿铁(全脂)", caloriesPer100g: 56, proteinPer100g: 3.2, fatPer100g: 2.0, carbsPer100g: 5.7, category: "饮品"),
        FoodSeedItem(name: "绿茶(无糖)", caloriesPer100g: 1, proteinPer100g: 0, fatPer100g: 0, carbsPer100g: 0.3, category: "饮品"),
    ]

    static func seed(context: ModelContext) {
        let descriptor = FetchDescriptor<Food>(predicate: #Predicate<Food> { $0.isCustom == false })
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0

        guard existingCount == 0 else { return }

        for item in commonFoods {
            let food = Food(
                name: item.name,
                caloriesPer100g: item.caloriesPer100g,
                proteinPer100g: item.proteinPer100g,
                fatPer100g: item.fatPer100g,
                carbsPer100g: item.carbsPer100g,
                category: item.category
            )
            context.insert(food)
        }

        try? context.save()
    }
}