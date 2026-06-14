import AVFoundation

// Audio session: volume, route, available TTS voices
final class MediaService: ObservableObject {
    @Published var volume = "—"
    @Published var route = "—"
    @Published var sampleRate = "—"
    @Published var voices = "—"

    private let session = AVAudioSession.sharedInstance()
    private let synth = AVSpeechSynthesizer()

    func refresh() {
        try? session.setActive(true)
        volume = "\(Int(session.outputVolume * 100))%"
        if let out = session.currentRoute.outputs.first {
            route = "\(out.portName) (\(out.portType.rawValue))"
        } else {
            route = "—"
        }
        sampleRate = String(format: "%.0f Гц", session.sampleRate)
        let all = AVSpeechSynthesisVoice.speechVoices()
        let ru = all.filter { $0.language.hasPrefix("ru") }.count
        voices = "\(all.count) всего · \(ru) русских"
    }

    // Speak a phrase with a specific voice/rate/pitch
    func speak(_ text: String, language: String = "ru-RU", rate: Float = AVSpeechUtteranceDefaultSpeechRate, pitch: Float = 1.0) {
        if synth.isSpeaking { synth.stopSpeaking(at: .immediate) }
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(language: language)
        u.rate = rate
        u.pitchMultiplier = pitch
        synth.speak(u)
    }
}
