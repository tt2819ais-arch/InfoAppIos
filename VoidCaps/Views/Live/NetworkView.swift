import SwiftUI

struct NetworkView: View {
    let title: String
    @StateObject private var net = NetworkService()

    var body: some View {
        ScreenScaffold(title: title) {
            LiveSection(title: "Подключение", api: "NWPathMonitor().pathUpdateHandler") {
                InfoRow(label: "Статус", value: net.status)
                InfoRow(label: "Интерфейс", value: net.interface)
                InfoRow(label: "Дорогой трафик", value: net.expensive ? "Да" : "Нет")
                InfoRow(label: "Ограниченный режим", value: net.constrained ? "Да" : "Нет")
            }
            Text("Включи/выключи Wi‑Fi или авиарежим — значения обновятся в реальном времени.")
                .font(.system(size: 12))
                .foregroundColor(VoidColor.textTertiary)
                .padding(.horizontal, 4)
        }
        .onAppear { net.start() }
        .onDisappear { net.stop() }
    }
}
