import Foundation

final class OlisStore {
    static let shared = OlisStore()

    private let key = "olis.widget.state.v2"
    private let suiteName = "group.com.tawheedxd.olis"

    private var defaults: UserDefaults {
        UserDefaults(suiteName: suiteName) ?? .standard
    }

    func load(now: Date = Date()) -> OlisState {
        guard
            let data = defaults.data(forKey: key),
            let saved = try? JSONDecoder().decode(OlisState.self, from: data)
        else {
            let state = OlisState.initial
            save(state)
            return state
        }

        let updated = OlisRules.applyTimeDecay(to: saved, now: now)
        save(updated)
        return updated
    }

    func save(_ state: OlisState) {
        guard let data = try? JSONEncoder().encode(state) else { return }
        defaults.set(data, forKey: key)
    }

    func pet(now: Date = Date()) -> OlisState {
        var state = load(now: now)

        if OlisRules.isSleeping(at: now) {
            state.reaction = .sleeping
            state.lastPhrase = OlisPhrases.sleeping(owner: state.ownerName)
            save(state)
            return state
        }

        state.joy = min(100, state.joy + OlisRules.petJoyGain)
        state.reaction = .happy
        state.lastPhrase = OlisPhrases.afterPet(owner: state.ownerName)
        state.lastUpdatedAt = now
        save(state)
        return state
    }

    func feed(_ food: OlisFood, now: Date = Date()) -> OlisState {
        var state = load(now: now)

        if OlisRules.isSleeping(at: now) {
            state.reaction = .sleeping
            state.lastPhrase = OlisPhrases.sleeping(owner: state.ownerName)
            save(state)
            return state
        }

        // При нулевой радости Олис игнорирует еду.
        guard state.joy > 0 else {
            state.reaction = .sad
            state.lastPhrase = OlisPhrases.sad(owner: state.ownerName)
            save(state)
            return state
        }

        state.satiety = min(100, state.satiety + food.satietyGain)
        state.reaction = .eating
        state.lastPhrase = OlisPhrases.afterFood(owner: state.ownerName)
        state.lastUpdatedAt = now
        save(state)
        return state
    }

    func setOwnerName(_ name: String, now: Date = Date()) {
        var state = load(now: now)
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        state.ownerName = trimmed.isEmpty ? "Оля" : trimmed
        state.lastUpdatedAt = now
        save(state)
    }
}
