import SwiftUI
import SwiftData

@main
struct FitSelfApp: App {
    @AppStorage("appearanceTheme") private var appearanceTheme: String = "system"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    ThemeManager.apply(appearanceTheme)
                }
                .onChange(of: appearanceTheme) { _, newValue in
                    ThemeManager.apply(newValue)
                }
        }
        .modelContainer(for: [
            UserProfile.self,
            Workout.self,
            WorkoutExercise.self,
            WorkoutSet.self,
            Food.self,
            FoodEntry.self,
            BodyMeasurement.self,
            WaterEntry.self
        ]) { result in
            if case .success(let container) = result {
                let context = container.mainContext
                FoodDatabaseSeeder.seed(context: context)
            }
        }
    }
}

enum ThemeManager {
    @MainActor
    static func apply(_ theme: String) {
        let style: UIUserInterfaceStyle
        switch theme {
        case "light": style = .light
        case "dark": style = .dark
        default: style = .unspecified
        }

        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.overrideUserInterfaceStyle = style }
    }
}