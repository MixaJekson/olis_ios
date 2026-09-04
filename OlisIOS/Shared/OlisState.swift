import Foundation

struct OlisState: Codable, Equatable {
    var joy: Int
    var satiety: Int
    var lastUpdatedAt: Date
    var ownerName: String
    var lastPhrase: String
    var reaction: OlisReaction

    static let initial = OlisState(
        joy: 100,
        satiety: 100,
        lastUpdatedAt: Date(),
        ownerName: "Оля",
        lastPhrase: "Я тут.",
        reaction: .idle
    )

    var hunger: Int { 100 - satiety }
    var sadness: Int { 100 - joy }
}
