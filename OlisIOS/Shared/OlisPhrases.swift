import Foundation

enum OlisPhrases {
    static func idle(owner: String) -> String {
        [
            "Я рядом.",
            "Можешь меня погладить.",
            "Еда справа. Я сам её не возьму.",
            "Чем занимаешься, \(owner)?",
            "Я всё вижу."
        ][Int.random(in: 0..<5)]
    }

    static func afterPet(owner: String) -> String {
        [
            "Вот так лучше.",
            "Ещё.",
            "\(owner), у тебя хорошо получается.",
            "Ладно, это было приятно."
        ][Int.random(in: 0..<4)]
    }

    static func afterFood(owner: String) -> String {
        [
            "Вкусно.",
            "Одобряю.",
            "Спасибо, \(owner).",
            "Вот теперь другое дело."
        ][Int.random(in: 0..<4)]
    }

    static func hungry(owner: String) -> String {
        [
            "Я вообще-то голодный.",
            "\(owner)... еда справа.",
            "Тут случайно ничего съедобного нет?"
        ][Int.random(in: 0..<3)]
    }

    static func sad(owner: String) -> String {
        [
            "Не хочу сейчас есть.",
            "\(owner)... сначала погладь меня.",
            "Мне грустно."
        ][Int.random(in: 0..<3)]
    }

    static func compliment(owner: String) -> String {
        [
            "\(owner), ты сегодня особенно милая.",
            "Мне нравится быть рядом с тобой, \(owner).",
            "\(owner), ты знаешь, что ты красивая?",
            "Я просто смотрю на тебя. Ничего такого."
        ][Int.random(in: 0..<4)]
    }

    static func sleeping(owner: String) -> String {
        "Сплю вместе с \(owner)…"
    }
}
