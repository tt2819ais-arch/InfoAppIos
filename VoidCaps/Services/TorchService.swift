import AVFoundation

// Torch / flashlight control
final class TorchService: ObservableObject {
    @Published var isOn = false
    @Published var level: Float = 1.0

    var hasTorch: Bool {
        AVCaptureDevice.default(for: .video)?.hasTorch ?? false
    }

    func toggle() {
        setOn(!isOn, level: level)
    }

    func setOn(_ on: Bool, level: Float) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if on {
                let lvl = max(0.001, min(level, 1.0))
                try device.setTorchModeOn(level: lvl)
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
            DispatchQueue.main.async { self.isOn = on }
        } catch {
            // ignore
        }
    }
}
