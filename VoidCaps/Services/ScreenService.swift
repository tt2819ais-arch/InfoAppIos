import UIKit
import Combine

// Screen brightness, idle timer, capture detection
final class ScreenService: ObservableObject {
    @Published var brightness: Double = Double(UIScreen.main.brightness)
    @Published var idleDisabled = false
    @Published var isCaptured = UIScreen.main.isCaptured
    @Published var lastEvent = "—"

    private var observers: [NSObjectProtocol] = []

    func setBrightness(_ v: Double) {
        brightness = v
        UIScreen.main.brightness = CGFloat(v)
    }

    func setIdleDisabled(_ on: Bool) {
        idleDisabled = on
        UIApplication.shared.isIdleTimerDisabled = on
    }

    func startMonitoring() {
        let nc = NotificationCenter.default
        observers.append(nc.addObserver(forName: UIApplication.userDidTakeScreenshotNotification,
                                        object: nil, queue: .main) { [weak self] _ in
            self?.lastEvent = "Сделан скриншот ✦"
        })
        observers.append(nc.addObserver(forName: UIScreen.capturedDidChangeNotification,
                                        object: nil, queue: .main) { [weak self] _ in
            let cap = UIScreen.main.isCaptured
            self?.isCaptured = cap
            self?.lastEvent = cap ? "Идёт запись экрана" : "Запись остановлена"
        })
    }

    func stopMonitoring() {
        observers.forEach { NotificationCenter.default.removeObserver($0) }
        observers.removeAll()
    }

    var pointSize: String {
        let b = UIScreen.main.bounds
        return "\(Int(b.width))×\(Int(b.height)) pt"
    }
    var pixelSize: String {
        let n = UIScreen.main.nativeBounds
        return "\(Int(n.width))×\(Int(n.height)) px"
    }
    var scale: String { "@\(Int(UIScreen.main.scale))x" }
    var refreshRate: String { "\(UIScreen.main.maximumFramesPerSecond) Гц" }
    var hdr: String {
        let h = UIScreen.main.potentialEDRHeadroom
        return h > 1.0 ? String(format: "HDR · headroom %.1f", h) : "SDR"
    }
    var safeArea: String {
        let scenes = UIApplication.shared.connectedScenes
        let window = (scenes.first as? UIWindowScene)?.windows.first
        let i = window?.safeAreaInsets ?? .zero
        return String(format: "↑%.0f ↓%.0f", i.top, i.bottom)
    }
}
