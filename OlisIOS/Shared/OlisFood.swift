import Foundation

enum OlisFood: String, Codable, CaseIterable {
    case cherry
    case fish
    case chicken

    var satietyGain: Int {
        switch self {
        case .cherry: return 15
        case .fish: return 25
        case .chicken: return 35
        }
    }

    var symbol: String {
        switch self {
        case .cherry: return "🍒"
        case .fish: return "🐟"
        case .chicken: return "🍗"
        }
    }

    static func current(at date: Date = Date()) -> OlisFood {
        // Еда меняется каждые 15 минут и заменяет предыдущую.
        let slot = Int(date.timeIntervalSince1970 / 900)
        return allCases[abs(slot) % allCases.count]
    }
}
