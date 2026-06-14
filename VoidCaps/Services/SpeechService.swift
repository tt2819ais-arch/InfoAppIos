import AVFoundation

// Text-to-speech
final class SpeechService {
    static let shared = SpeechService()
    private let synth = AVSpeechSynthesizer()

    func speak(_ text: String, language: String = "ru-RU") {
        if synth.isSpeaking { synth.stopSpeaking(at: .immediate) }
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(language: language)
        u.rate = AVSpeechUtteranceDefaultSpeechRate
        u.pitchMultiplier = 1.0
        synth.speak(u)
    }
}
