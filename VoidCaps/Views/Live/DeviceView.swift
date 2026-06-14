import SwiftUI

struct DeviceView: View {
    let title: String
    @StateObject private var device = DeviceService()
    @State private var timer: Timer?

    var body: some View {
        ScreenScaffold(title: title) {
            LiveSection(title: "Устройство", api: "UIDevice.current") {
                InfoRow(label: "Имя", value: device.name)
                InfoRow(label: "Модель", value: device.model)
                InfoRow(label: "Система", value: "\(device.systemName) \(device.systemVersion)")
                InfoRow(label: "Экран", value: device.screenSize)
            }

            LiveSection(title: "Батарея", api: "UIDevice.batteryLevel · batteryState") {
                InfoRow(label: "Заряд", value: device.battery)
                InfoRow(label: "Состояние", value: device.batteryState)
                InfoRow(label: "Энергосбережение", value: device.lowPower)
            }

            LiveSection(title: "Система", api: "ProcessInfo.processInfo") {
                InfoRow(label: "Температура", value: device.thermal)
                InfoRow(label: "Ядра CPU", value: device.processorCount)
                InfoRow(label: "ОЗУ", value: device.physicalMemory)
                InfoRow(label: "Время работы", value: device.uptime)
            }

            LiveSection(title: "Хранилище", api: "FileManager.attributesOfFileSystem") {
                InfoRow(label: "Всего", value: device.diskTotal)
                InfoRow(label: "Свободно", value: device.diskFree)
            }

            LiveSection(title: "Идентификатор", api: "UIDevice.identifierForVendor") {
                Text(device.identifierForVendor)
                    .voidMono(11)
                    .foregroundColor(VoidColor.textSecondary)
                    .textSelection(.enabled)
            }
        }
        .onAppear {
            device.enableBatteryMonitoring()
            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in device.refresh() }
        }
        .onDisappear { timer?.invalidate() }
    }
}
