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

    var nativeResolution: String {
        let n = UIScreen.main.nativeBounds
        return "\(Int(n.width))×\(Int(n.height)) px"
    }

    var refreshRate: String { "\(UIScreen.main.maximumFramesPerSecond) Гц" }

    var hdr: String {
        UIScreen.main.potentialEDRHeadroom > 1.0 ? "Поддерживается (HDR)" : "Стандартный (SDR)"
    }

    var idiom: String {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: return "iPhone"
        case .pad: return "iPad"
        case .mac: return "Mac"
        case .tv: return "TV"
        case .carPlay: return "CarPlay"
        case .vision: return "Vision"
        default: return "—"
        }
    }

    var locale: String { Locale.current.identifier }
    var languageCode: String {
        if #available(iOS 16.0, *) { return Locale.current.language.languageCode?.identifier ?? "—" }
        return Locale.current.languageCode ?? "—"
    }
    var timezone: String { TimeZone.current.identifier }
    var calendar: String { Calendar.current.identifier == .gregorian ? "Григорианский" : "\(Calendar.current.identifier)" }

    var orientation: String {
        switch UIDevice.current.orientation {
        case .portrait: return "Портрет"
        case .portraitUpsideDown: return "Портрет (перевёрнут)"
        case .landscapeLeft: return "Ландшафт (влево)"
        case .landscapeRight: return "Ландшафт (вправо)"
        case .faceUp: return "Экраном вверх"
        case .faceDown: return "Экраном вниз"
        default: return "Неизвестно"
        }
    }

    // Heuristic jailbreak detection — checks for common jailbreak artifacts
    var jailbreak: String {
        #if targetEnvironment(simulator)
        return "Симулятор"
        #else
        let paths = ["/Applications/Cydia.app", "/Library/MobileSubstrate/MobileSubstrate.dylib",
                     "/bin/bash", "/usr/sbin/sshd", "/etc/apt", "/private/var/lib/apt/"]
        for p in paths where FileManager.default.fileExists(atPath: p) { return "Обнаружены признаки JB" }
        // Try writing outside the sandbox
        let test = "/private/void_jb_test.txt"
        if (try? "x".write(toFile: test, atomically: true, encoding: .utf8)) != nil {
            try? FileManager.default.removeItem(atPath: test)
            return "Обнаружены признаки JB"
        }
        return "Не обнаружено"
        #endif
    }
}
