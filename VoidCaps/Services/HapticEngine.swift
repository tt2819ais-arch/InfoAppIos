import CoreHaptics
import UIKit

// Core Haptics — custom transient + continuous patterns
final class HapticEngineManager {
    static let shared = HapticEngineManager()
    private var engine: CHHapticEngine?
    var isSupported: Bool { CHHapticEngine.capabilitiesForHardware().supportsHaptics }

    private func ensureEngine() {
        guard isSupported else { return }
        if engine == nil {
            engine = try? CHHapticEngine()
            engine?.isAutoShutdownEnabled = true
            engine?.resetHandler = { [weak self] in try? self?.engine?.start() }
        }
        try? engine?.start()
    }

    // Single transient tap with intensity & sharpness
    func transient(intensity: Float, sharpness: Float) {
        guard isSupported else { Haptics.impact(.medium); return }
        ensureEngine()
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                .init(parameterID: .hapticIntensity, value: intensity),
                .init(parameterID: .hapticSharpness, value: sharpness)
            ],
            relativeTime: 0)
        playEvents([event])
    }

    // Continuous buzz
    func continuous(intensity: Float, sharpness: Float, duration: TimeInterval) {
        guard isSupported else { Haptics.impact(.heavy); return }
        ensureEngine()
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                .init(parameterID: .hapticIntensity, value: intensity),
                .init(parameterID: .hapticSharpness, value: sharpness)
            ],
            relativeTime: 0,
            duration: duration)
        playEvents([event])
    }

    // A rich pattern: heartbeat-like double + rising buzz
    func heartbeat() {
        guard isSupported else { Haptics.notification(.success); return }
        ensureEngine()
        var events: [CHHapticEvent] = []
        for i in 0..<2 {
            events.append(CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    .init(parameterID: .hapticIntensity, value: 1.0),
                    .init(parameterID: .hapticSharpness, value: 0.6)
                ],
                relativeTime: Double(i) * 0.18))
        }
        events.append(CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                .init(parameterID: .hapticIntensity, value: 0.6),
                .init(parameterID: .hapticSharpness, value: 0.3)
            ],
            relativeTime: 0.45, duration: 0.4))
        playEvents(events)
    }

    private func playEvents(_ events: [CHHapticEvent]) {
        guard let engine = engine else { return }
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            // ignore — fall back silently
        }
    }
}
