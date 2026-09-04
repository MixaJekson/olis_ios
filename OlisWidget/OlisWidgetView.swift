import SwiftUI
import WidgetKit
import UIKit

struct OlisWidgetView: View {
    let entry: OlisEntry

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.clear

                VStack {
                    HStack {
                        StatusDot(value: entry.state.joy, systemImage: "heart.fill")
                        Spacer()
                        StatusDot(value: entry.state.satiety, systemImage: "fork.knife")
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 6)

                    Spacer()
                }

                HStack(alignment: .bottom, spacing: 0) {
                    Button(intent: PetOlisIntent()) {
                        BundledPNG(name: spriteName)
                            .scaledToFit()
                            .frame(
                                width: min(geo.size.width * 0.50, 170),
                                height: min(geo.size.height * 0.72, 110)
                            )
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .disabled(entry.state.reaction == .sleeping)
                    .accessibilityLabel("Погладить Олиса")

                    Spacer(minLength: 4)

                    if entry.state.reaction != .sleeping {
                        Button(intent: FeedOlisIntent(food: entry.food.rawValue)) {
                            BundledPNG(name: foodImageName)
                                .scaledToFit()
                                .frame(
                                    width: min(geo.size.width * 0.18, 56),
                                    height: min(geo.size.height * 0.30, 48)
                                )
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Покормить Олиса")
                        .padding(.trailing, 18)
                        .padding(.bottom, 22)
                    }
                }
                .padding(.leading, 8)
                .padding(.bottom, 4)

                VStack {
                    Spacer()

                    if !entry.phrase.isEmpty {
                        Text(entry.phrase)
                            .font(.caption2)
                            .lineLimit(1)
                            .minimumScaleFactor(0.70)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.thinMaterial, in: Capsule())
                            .padding(.bottom, 4)
                    }
                }
            }
        }
    }

    private var spriteName: String {
        let frame = abs(Int(entry.date.timeIntervalSince1970 / 15)) % 8

        switch entry.state.reaction {
        case .sleeping:
            return String(format: "olis_sleep_%02d", frame)
        case .sad:
            return String(format: "olis_sad_%02d", frame)
        case .hungry, .veryHungry:
            return String(format: "olis_curious_%02d", frame)
        case .happy:
            return String(format: "olis_happy_%02d", frame)
        case .flirting, .smug:
            return String(format: "olis_smug_%02d", frame)
        case .eating:
            return String(format: "olis_eat_%02d", frame)
        case .idle:
            return String(format: "olis_idle_%02d", frame)
        }
    }

    private var foodImageName: String {
        switch entry.food {
        case .cherry: return "food_cherry"
        case .fish: return "food_fish"
        case .chicken: return "food_chicken"
        }
    }
}

private struct BundledPNG: View {
    let name: String

    var body: some View {
        Group {
            if let image = loadImage() {
                Image(uiImage: image)
                    .resizable()
                    .interpolation(.none)
            } else {
                // Явный fallback вместо "пустоты": если ресурс снова потеряется,
                // сразу будет видно имя отсутствующего файла.
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.secondary.opacity(0.12))
                    Text(name)
                        .font(.system(size: 7))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }

    private func loadImage() -> UIImage? {
        if let url = Bundle.main.url(forResource: name, withExtension: "png"),
           let image = UIImage(contentsOfFile: url.path) {
            return image
        }

        if let url = Bundle.main.url(
            forResource: name,
            withExtension: "png",
            subdirectory: "Resources"
        ),
        let image = UIImage(contentsOfFile: url.path) {
            return image
        }

        if let image = UIImage(named: name, in: Bundle.main, compatibleWith: nil) {
            return image
        }

        return nil
    }
}

private struct StatusDot: View {
    let value: Int
    let systemImage: String

    private var progress: Double {
        max(0, min(1, Double(value) / 100.0))
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(.secondary.opacity(0.28), lineWidth: 4)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    .primary,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            Image(systemName: systemImage)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.primary)
        }
        .frame(width: 24, height: 24)
        .accessibilityValue("\(value) процентов")
    }
}
