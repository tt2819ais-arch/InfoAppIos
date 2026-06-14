import SwiftUI

struct ScreenView: View {
    let title: String
    @StateObject private var screen = ScreenService()

    var body: some View {
        ScreenScaffold(title: title) {
            LiveSection(title: "Яркость экрана", api: "UIScreen.main.brightness") {
                HStack {
                    Image(systemName: "sun.min").foregroundColor(VoidColor.textTertiary)
                    Slider(value: Binding(
                        get: { screen.brightness },
                        set: { screen.setBrightness($0) }), in: 0...1)
                    .tint(VoidColor.accent)
                    Image(systemName: "sun.max.fill").foregroundColor(VoidColor.accent)
                }
                InfoRow(label: "Текущая яркость", value: "\(Int(screen.brightness * 100))%")
            }

            LiveSection(title: "Автоблокировка", api: "UIApplication.isIdleTimerDisabled") {
                Toggle(isOn: Binding(
                    get: { screen.idleDisabled },
                    set: { screen.setIdleDisabled($0) })) {
                    Text(screen.idleDisabled ? "Экран не гаснет" : "Обычный режим")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(VoidColor.textPrimary)
                }
                .tint(VoidColor.accent)
            }

            LiveSection(title: "Захват экрана", api: "UIScreen.main.isCaptured · userDidTakeScreenshot") {
                InfoRow(label: "Идёт запись экрана", value: screen.isCaptured ? "Да" : "Нет")
                InfoRow(label: "Последнее событие", value: screen.lastEvent)
                Text("Сделай скриншот или запусти запись экрана — событие появится здесь.")
                    .font(.system(size: 12))
                    .foregroundColor(VoidColor.textTertiary)
            }
        }
        .onAppear { screen.startMonitoring() }
        .onDisappear {
            screen.stopMonitoring()
            screen.setIdleDisabled(false)
        }
    }
}
