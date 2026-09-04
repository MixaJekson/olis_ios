import WidgetKit
import SwiftUI

struct OlisEntry: TimelineEntry {
    let date: Date
    let state: OlisState
    let food: OlisFood
    let phrase: String
}

struct OlisProvider: TimelineProvider {
    func placeholder(in context: Context) -> OlisEntry {
        OlisEntry(
            date: Date(),
            state: .initial,
            food: .chicken,
            phrase: "Я тут."
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (OlisEntry) -> Void) {
        completion(makeEntry(at: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<OlisEntry>) -> Void) {
        let now = Date()
        let entry = makeEntry(at: now)

        // WidgetKit сам решает точный момент обновления.
        // Состояние вычисляется по реальному прошедшему времени, поэтому
        // нам не требуется запускаться каждую минуту.
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: now)!
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }

    private func makeEntry(at date: Date) -> OlisEntry {
        var state = OlisStore.shared.load(now: date)
        let sleeping = OlisRules.isSleeping(at: date)

        if sleeping {
            state.reaction = .sleeping
            state.lastPhrase = OlisPhrases.sleeping(owner: state.ownerName)
        } else if state.joy == 0 {
            state.reaction = .sad
            state.lastPhrase = OlisPhrases.sad(owner: state.ownerName)
        } else if state.satiety <= 20 {
            state.reaction = .hungry
            state.lastPhrase = OlisPhrases.hungry(owner: state.ownerName)
        } else {
            // Иногда заигрывает. Стабильно в пределах 15-минутного слота.
            let slot = Int(date.timeIntervalSince1970 / 900)
            if slot % 5 == 0 && state.joy >= 50 {
                state.reaction = .flirting
                state.lastPhrase = OlisPhrases.compliment(owner: state.ownerName)
            }
        }

        OlisStore.shared.save(state)

        return OlisEntry(
            date: date,
            state: state,
            food: OlisFood.current(at: date),
            phrase: state.lastPhrase
        )
    }
}

struct OlisWidget: Widget {
    let kind = "OlisWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OlisProvider()) { entry in
            OlisWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Олис")
        .description("Олис живёт на главном экране: гладь его и корми едой рядом.")
        .supportedFamilies([.systemMedium])
    }
}
