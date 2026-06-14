import SwiftUI

struct NetworkView: View {
    let title: String
    @StateObject private var net = NetworkService()
    @StateObject private var ip = IPService()

    var body: some View {
        ScreenScaffold(title: title) {
            LiveSection(title: "Подключение", api: "NWPathMonitor().pathUpdateHandler") {
                InfoRow(label: "Статус", value: net.status)
                InfoRow(label: "Интерфейс", value: net.interface)
                InfoRow(label: "Дорогой трафик", value: net.expensive ? "Да" : "Нет")
                InfoRow(label: "Ограниченный режим", value: net.constrained ? "Да" : "Нет")
            }

            LiveSection(title: "Локальный IP", api: "getifaddrs · getnameinfo (AF_INET)") {
                InfoRow(label: "Wi‑Fi (en0)", value: ip.wifiIP)
                InfoRow(label: "Сотовая (pdp_ip0)", value: ip.cellularIP)
                if !ip.allInterfaces.isEmpty {
                    ForEach(ip.allInterfaces, id: \.self) { line in
                        Text(line).voidMono(11).foregroundColor(VoidColor.textSecondary)
                    }
                }
            }

            LiveSection(title: "Публичный IP", api: "URLSession → api.ipify.org") {
                InfoRow(label: "Внешний адрес", value: ip.publicIP)
            }

            LiveSection(title: "Оператор связи", api: "CTTelephonyNetworkInfo (deprecated)") {
                InfoRow(label: "Оператор", value: ip.carrier)
                InfoRow(label: "Тип сети", value: ip.radio)
                Text("carrierName устарел в iOS 16+ и часто возвращает «—».")
                    .font(.system(size: 12))
                    .foregroundColor(VoidColor.textTertiary)
            }

            Text("Включи/выключи Wi‑Fi или авиарежим — значения обновятся.")
                .font(.system(size: 12))
                .foregroundColor(VoidColor.textTertiary)
                .padding(.horizontal, 4)
        }
        .onAppear { net.start(); ip.refresh() }
        .onDisappear { net.stop() }
    }
}
