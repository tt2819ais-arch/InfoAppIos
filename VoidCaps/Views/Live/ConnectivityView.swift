import SwiftUI

struct ConnectivityView: View {
    let title: String
    @StateObject private var conn = ConnectivityService()

    var body: some View {
        ScreenScaffold(title: title) {
            LiveSection(title: "Bluetooth", api: "CBCentralManager.state") {
                InfoRow(label: "Состояние", value: conn.bluetooth)
                Text("Создание CBCentralManager вызывает системный запрос доступа к Bluetooth.")
                    .font(.system(size: 12))
                    .foregroundColor(VoidColor.textTertiary)
            }

            LiveSection(title: "NFC", api: "NFCNDEFReaderSession.readingAvailable") {
                InfoRow(label: "Чтение меток", value: conn.nfcAvailable)
                Text("Запуск NFC-сессии требует платный entitlement и подпись приложения.")
                    .font(.system(size: 12))
                    .foregroundColor(VoidColor.textTertiary)
            }
        }
        .onAppear { conn.start() }
    }
}
