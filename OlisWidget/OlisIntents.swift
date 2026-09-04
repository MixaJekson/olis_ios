import AppIntents
import WidgetKit

struct PetOlisIntent: AppIntent {
    static var title: LocalizedStringResource = "Погладить Олиса"
    static var description = IntentDescription("Добавляет Олису 30 радости.")

    func perform() async throws -> some IntentResult {
        _ = OlisStore.shared.pet()
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct FeedOlisIntent: AppIntent {
    static var title: LocalizedStringResource = "Покормить Олиса"

    @Parameter(title: "Еда")
    var food: String

    init() {
        self.food = OlisFood.chicken.rawValue
    }

    init(food: String) {
        self.food = food
    }

    func perform() async throws -> some IntentResult {
        let selected = OlisFood(rawValue: food) ?? .chicken
        _ = OlisStore.shared.feed(selected)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
