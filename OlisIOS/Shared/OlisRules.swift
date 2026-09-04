import Foundation

enum OlisRules {
    static let sleepStartHour = 23
    static let sleepEndHour = 8
    static let petJoyGain = 30

    static func isSleeping(at date: Date, calendar: Calendar = .current) -> Bool {
        let hour = calendar.component(.hour, from: date)
        return hour >= sleepStartHour || hour < sleepEndHour
    }

    static func applyTimeDecay(to input: OlisState, now: Date = Date(), calendar: Calendar = .current) -> OlisState {
        guard now > input.lastUpdatedAt else { return input }

        var state = input

        // Считаем только полностью прошедшие минуты.
        let elapsed = Int(now.timeIntervalSince(state.lastUpdatedAt) / 60)
        guard elapsed > 0 else { return state }

        var cursor = state.lastUpdatedAt

        for _ in 0..<elapsed {
            if state.joy == 0 && state.satiety == 0 {
                break
            }

            cursor = cursor.addingTimeInterval(60)

            if isSleeping(at: cursor, calendar: calendar) {
                continue
            }

            let joyPenalty = state.satiety == 0 ? 2 : 0
            let satietyPenalty = state.joy == 0 ? 2 : 0

            state.joy = max(0, state.joy - 1 - joyPenalty)
            state.satiety = max(0, state.satiety - 1 - satietyPenalty)
        }

        state.lastUpdatedAt = now
        state.reaction = reaction(for: state, now: now)
        return state
    }

    static func reaction(for state: OlisState, now: Date = Date()) -> OlisReaction {
        if isSleeping(at: now) { return .sleeping }
        if state.joy <= 10 { return .sad }
        if state.satiety <= 10 { return .veryHungry }
        if state.satiety <= 30 { return .hungry }
        if state.joy >= 80 && state.satiety >= 60 { return .smug }
        return .idle
    }
}
