import UIKit
import Foundation

// Device & system information
final class DeviceService: ObservableObject {
    @Published var battery = "—"
    @Published var batteryState = "—"
    @Published var thermal = "—"
    @Published var lowPower = "—"

    func enableBatteryMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        refresh()
    }

    func refresh() {
        let d = UIDevice.current
        let lvl = d.batteryLevel
        battery = lvl < 0 ? "недоступно" : "\(Int(lvl * 100))%"
        switch d.batteryState {
        case .charging: batteryState = "Заряжается"
        case .full: batteryState = "Полный"
        case .unplugged: batteryState = "От батареи"
        default: batteryState = "Неизвестно"
        }
        switch ProcessInfo.processInfo.thermalState {
        case .nominal: thermal = "Нормальная"
        case .fair: thermal = "Умеренная"
        case .serious: thermal = "Высокая"
        case .critical: thermal = "Критическая"
        @unknown default: thermal = "—"
        }
        lowPower = ProcessInfo.processInfo.isLowPowerModeEnabled ? "Включён" : "Выключен"
    }

    var name: String { UIDevice.current.name }
    var model: String { UIDevice.current.model }
    var systemName: String { UIDevice.current.systemName }
    var systemVersion: String { UIDevice.current.systemVersion }
    var identifierForVendor: String { UIDevice.current.identifierForVendor?.uuidString ?? "—" }

    var uptime: String {
        let t = ProcessInfo.processInfo.systemUptime
        let h = Int(t) / 3600, m = (Int(t) % 3600) / 60
        return "\(h) ч \(m) мин"
    }

    var processorCount: String { "\(ProcessInfo.processInfo.processorCount)" }

    var physicalMemory: String {
        ByteCountFormatter.string(fromByteCount: Int64(ProcessInfo.processInfo.physicalMemory), countStyle: .memory)
    }

    var diskTotal: String { diskString(for: .systemSize) }
    var diskFree: String { diskString(for: .systemFreeSize) }

    private func diskString(for key: FileAttributeKey) -> String {
        guard let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
              let bytes = attrs[key] as? NSNumber else { return "—" }
        return ByteCountFormatter.string(fromByteCount: bytes.int64Value, countStyle: .file)
    }

    var screenSize: String {
        let b = UIScreen.main.bounds
        return "\(Int(b.width))×\(Int(b.height)) pt @\(Int(UIScreen.main.scale))x"
    }
}
