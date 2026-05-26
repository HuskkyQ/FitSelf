import SwiftUI
import SwiftData

struct NutritionView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = NutritionViewModel()
    @State private var showingAddFood = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    calorieOverviewSection

                    macroBreakdownSection

                    mealSection(title: "早餐", icon: "sunrise.fill", entries: viewModel.breakfastEntries, mealKey: "breakfast")
                    mealSection(title: "午餐", icon: "sun.max.fill", entries: viewModel.lunchEntries, mealKey: "lunch")
                    mealSection(title: "晚餐", icon: "sunset.fill", entries: viewModel.dinnerEntries, mealKey: "dinner")
                    mealSection(title: "加餐", icon: "cup.and.saucer.fill", entries: viewModel.snackEntries, mealKey: "snack")

                    waterSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(Color.appBackground)
            .navigationTitle("饮食")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddFood = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.appPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingAddFood) {
                AddFoodView(viewModel: viewModel)
            }
            .task {
                viewModel.configure(context: modelContext)
                await viewModel.loadData()
            }
            .refreshable {
                await viewModel.loadData()
            }
        }
    }

    private var calorieOverviewSection: some View {
        VStack(spacing: 16) {
            Text("剩余可摄入")
                .font(.appCaption)
                .foregroundStyle(Color.appMutedForeground)

            ZStack {
                Circle()
                    .stroke(Color.appMuted.opacity(0.2), lineWidth: 16)

                Circle()
                    .trim(from: 0, to: min(viewModel.calorieProgress, 1.0))
                    .stroke(
                        viewModel.calorieProgress >= 1.0 ? Color.appDestructive : Color.chartCalories,
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 4) {
                    Text("\(viewModel.remainingCalories)")
                        .font(.appHero)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.appForeground)
                    Text("/ \(viewModel.calorieGoal) kcal")
                        .font(.appCaption)
                        .foregroundStyle(Color.appMutedForeground)
                }
            }
            .frame(width: 160, height: 160)

            Text("已摄入 \(Int(viewModel.dailyCalories)) kcal")
                .font(.appCallout)
                .foregroundStyle(Color.appMutedForeground)
        }
        .padding(20)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var macroBreakdownSection: some View {
        HStack(spacing: 12) {
            macroBar(label: "蛋白质", value: viewModel.dailyProtein, goal: viewModel.proteinGoal, unit: "g", color: .chartProtein)
            macroBar(label: "碳水", value: viewModel.dailyCarbs, goal: viewModel.carbsGoal, unit: "g", color: .chartCarbs)
            macroBar(label: "脂肪", value: viewModel.dailyFat, goal: viewModel.fatGoal, unit: "g", color: .chartFat)
        }
    }

    private func macroBar(label: String, value: Double, goal: Double, unit: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.appCaption)
                .foregroundStyle(Color.appMutedForeground)

            Text(String(format: "%.0f", value))
                .font(.appTitle3)
                .fontWeight(.bold)
                .foregroundStyle(color)

            ProgressView(value: goal > 0 ? value / goal : 0)
                .tint(color)
                .scaleEffect(y: 2)

            Text("/ \(String(format: "%.0f", goal))\(unit)")
                .font(.appCaption2)
                .foregroundStyle(Color.appMutedForeground)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func mealSection(title: String, icon: String, entries: [FoodEntry], mealKey: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(Color.appPrimary)
                Text(title)
                    .font(.appTitle3)
                    .foregroundStyle(Color.appForeground)

                Spacer()

                let mealCalories = entries.reduce(0.0) { $0 + $1.calories }
                Text(String(format: "%.0f kcal", mealCalories))
                    .font(.appCallout)
                    .foregroundStyle(Color.appMutedForeground)

                Button {
                    showingAddFood = true
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundStyle(Color.appPrimary)
                }
            }

            if entries.isEmpty {
                Text("还没有记录")
                    .font(.appFootnote)
                    .foregroundStyle(Color.appMutedForeground)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 16)
            } else {
                ForEach(entries) { entry in
                    FoodEntryRow(entry: entry) {
                        viewModel.deleteEntry(entry)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var waterSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundStyle(Color.chartWater)
                Text("饮水记录")
                    .font(.appTitle3)
                    .foregroundStyle(Color.appForeground)

                Spacer()

                Text("\(viewModel.dailyWaterMl) / \(viewModel.waterGoal) ml")
                    .font(.appCallout)
                    .foregroundStyle(Color.appMutedForeground)
            }

            ProgressView(value: viewModel.waterProgress)
                .tint(Color.chartWater)
                .scaleEffect(y: 2)
                .padding(.vertical, 4)

            HStack(spacing: 12) {
                waterQuickAddButton(title: "一杯", subtitle: "200ml", amount: 200)
                waterQuickAddButton(title: "中杯", subtitle: "350ml", amount: 350)
                waterQuickAddButton(title: "大杯", subtitle: "500ml", amount: 500)
            }

            if !viewModel.waterEntries.isEmpty {
                ForEach(viewModel.waterEntries) { entry in
                    HStack {
                        Image(systemName: "drop.fill")
                            .font(.appCaption)
                            .foregroundStyle(Color.chartWater)
                        Text("\(entry.milliliters) ml")
                            .font(.appCallout)
                            .foregroundStyle(Color.appForeground)

                        Spacer()

                        Text(entry.recordedAt.formatted(date: .omitted, time: .shortened))
                            .font(.appCaption)
                            .foregroundStyle(Color.appMutedForeground)
                    }
                    .padding(.vertical, 4)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.deleteWater(entry)
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func waterQuickAddButton(title: String, subtitle: String, amount: Int) -> some View {
        Button {
            viewModel.addWater(ml: amount)
        } label: {
            VStack(spacing: 4) {
                Text(title)
                    .font(.appCaption)
                    .foregroundStyle(Color.appForeground)
                Text(subtitle)
                    .font(.appCaption2)
                    .foregroundStyle(Color.appMutedForeground)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.chartWater.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct FoodEntryRow: View {
    let entry: FoodEntry
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.food?.name ?? entry.customFoodName ?? "自定义食物")
                    .font(.appCallout)
                    .foregroundStyle(Color.appForeground)
                HStack(spacing: 8) {
                    Text(String(format: "%.0f kcal", entry.calories))
                    if entry.protein > 0 { Text("蛋白\(String(format: "%.0f", entry.protein))g") }
                    if entry.carbs > 0 { Text("碳水\(String(format: "%.0f", entry.carbs))g") }
                    if entry.fat > 0 { Text("脂肪\(String(format: "%.0f", entry.fat))g") }
                }
                .font(.appCaption2)
                .foregroundStyle(Color.appMutedForeground)
            }

            Spacer()

            Text(String(format: "%.0fg", entry.portionGrams))
                .font(.appCaption)
                .foregroundStyle(Color.appMutedForeground)
        }
        .padding(.vertical, 6)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("删除", systemImage: "trash")
            }
        }
    }
}

struct AddFoodView: View {
    let viewModel: NutritionViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedMeal = "lunch"
    @State private var portionGrams: Double = 100
    @State private var searchResults: [Food] = []
    @State private var showingCustomEntry = false

    let meals = [("breakfast", "早餐", "sunrise.fill"), ("lunch", "午餐", "sun.max.fill"), ("dinner", "晚餐", "sunset.fill"), ("snack", "加餐", "cup.and.saucer.fill")]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                mealPicker

                portionInput

                if !searchText.isEmpty {
                    searchResultsList
                } else {
                    commonFoodsList
                }
            }
            .navigationTitle("添加食物")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("自定义食物") {
                        showingCustomEntry = true
                    }
                    .foregroundStyle(Color.appPrimary)
                }
            }
            .searchable(text: $searchText, prompt: "搜索食物")
            .onChange(of: searchText) { _, newValue in
                searchFoods(query: newValue)
            }
            .sheet(isPresented: $showingCustomEntry) {
                CustomFoodEntryView(viewModel: viewModel, selectedMeal: selectedMeal)
            }
        }
    }

    private var mealPicker: some View {
        Picker("餐次", selection: $selectedMeal) {
            ForEach(meals, id: \.0) { key, label, _ in
                Text(label).tag(key)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 16)
    }

    private var portionInput: some View {
        HStack {
            Text("份量")
            TextField("100", value: $portionGrams, format: .number)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
                .frame(width: 80)
            Text("克")
        }
        .padding(.horizontal, 16)
    }

    private var commonFoodsList: some View {
        List {
            let categories = Dictionary(grouping: FoodDatabaseSeeder.commonFoods) { $0.category }
            let sortedCategories = categories.keys.sorted()

            ForEach(sortedCategories, id: \.self) { category in
                Section(category) {
                    ForEach(categories[category]!, id: \.name) { item in
                        Button {
                            let name = item.name
                            let descriptor = FetchDescriptor<Food>(
                                predicate: #Predicate<Food> { $0.name == name }
                            )
                            if let food = try? modelContext.fetch(descriptor).first {
                                viewModel.addEntry(food: food, portionGrams: portionGrams, meal: selectedMeal)
                            }
                            dismiss()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                        .font(.appCallout)
                                        .foregroundStyle(Color.appForeground)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text(String(format: "%.0f kcal", item.caloriesPer100g * portionGrams / 100))
                                        .font(.appCallout)
                                        .foregroundStyle(Color.chartCalories)
                                    Text("每100g")
                                        .font(.appCaption2)
                                        .foregroundStyle(Color.appMutedForeground)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private var searchResultsList: some View {
        List(searchResults) { food in
            Button {
                viewModel.addEntry(food: food, portionGrams: portionGrams, meal: selectedMeal)
                dismiss()
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(food.name)
                            .font(.appCallout)
                            .foregroundStyle(Color.appForeground)
                        if let brand = food.brand {
                            Text(brand)
                                .font(.appCaption2)
                                .foregroundStyle(Color.appMutedForeground)
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(String(format: "%.0f kcal", food.caloriesPer100g * portionGrams / 100))
                            .font(.appCallout)
                            .foregroundStyle(Color.chartCalories)
                        Text("每100g")
                            .font(.appCaption2)
                            .foregroundStyle(Color.appMutedForeground)
                    }
                }
            }
        }
    }

    private func searchFoods(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        let descriptor = FetchDescriptor<Food>(
            predicate: #Predicate<Food> { $0.name.contains(query) }
        )
        searchResults = (try? modelContext.fetch(descriptor)) ?? []
    }
}

struct CustomFoodEntryView: View {
    let viewModel: NutritionViewModel
    let selectedMeal: String
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var calories: Double = 0
    @State private var protein: Double = 0
    @State private var fat: Double = 0
    @State private var carbs: Double = 0
    @State private var portionGrams: Double = 100

    var body: some View {
        NavigationStack {
            Form {
                Section("食物信息") {
                    TextField("食物名称", text: $name)
                    HStack {
                        Text("份量")
                        TextField("100", value: $portionGrams, format: .number)
                            .keyboardType(.decimalPad)
                        Text("克")
                    }
                }

                Section("营养（按份量计算）") {
                    HStack {
                        Text("热量")
                        Spacer()
                        TextField("0", value: $calories, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("kcal")
                    }
                    HStack {
                        Text("蛋白质")
                        Spacer()
                        TextField("0", value: $protein, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("g")
                    }
                    HStack {
                        Text("碳水")
                        Spacer()
                        TextField("0", value: $carbs, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("g")
                    }
                    HStack {
                        Text("脂肪")
                        Spacer()
                        TextField("0", value: $fat, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("g")
                    }
                }
            }
            .navigationTitle("自定义食物")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("添加") {
                        viewModel.addEntry(
                            food: nil,
                            portionGrams: portionGrams,
                            meal: selectedMeal,
                            calories: calories,
                            protein: protein,
                            fat: fat,
                            carbs: carbs
                        )
                        dismiss()
                    }
                    .disabled(name.isEmpty || calories <= 0)
                }
            }
        }
    }
}