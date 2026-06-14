import AudioToolbox
import UIKit

// AudioServicesPlaySystemSound wrappers
enum SystemSounds {
    static func play(_ id: SystemSoundID) {
        AudioServicesPlaySystemSound(id)
    }

    // Vibrate via AudioServices (works on all devices, ignores silent switch)
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) // 4095
    }

    static func vibrateWithAlert(_ id: SystemSoundID) {
        AudioServicesPlayAlertSound(id)
    }
}
