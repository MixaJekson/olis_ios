import SwiftUI
import WidgetKit

struct SettingsView: View {
    @State private var ownerName = ""
    @State private var state = OlisState.initial

    var body: some View {
        NavigationStack {
            Form {
                Section("Как пользоваться") {
                    Label("Нажми на Олиса — погладить (+30 радости)", systemImage: "hand.tap")
                    Label("Нажми на еду справа — покормить", systemImage: "fork.knife")
                    Label("С 23:00 до 08:00 Олис спит", systemImage: "moon.zzz")

                    Text("Если радость упала до нуля, Олис сначала хочет поглаживания и только после этого принимает еду.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("Хозяин") {
                    TextField("Имя", text: $ownerName)

                    Button("Сохранить имя") {
                        OlisStore.shared.setOwnerName(ownerName)
                        state = OlisStore.shared.load()
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }

                Section("Состояние") {
                    LabeledContent("Радость", value: "\(state.joy)%")
                    LabeledContent("Сытость", value: "\(state.satiety)%")
                    LabeledContent("Грусть", value: "\(state.sadness)%")
                    LabeledContent("Голод", value: "\(state.hunger)%")
                }

                Section("Виджет") {
                    Text("Добавь medium-виджет «Олис» на главный экран. Здесь остаются только настройки и подсказка.")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Олис")
            .onAppear {
                state = OlisStore.shared.load()
                ownerName = state.ownerName
            }
        }
    }
}
