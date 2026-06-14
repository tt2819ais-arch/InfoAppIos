import SwiftUI

struct MediaView: View {
    let title: String
    @StateObject private var media = MediaService()
    @State private var timer: Timer?

    var body: some View {
        ScreenScaffold(title: title) {
            LiveSection(title: "Громкость", api: "AVAudioSession.outputVolume") {
                InfoRow(label: "Системная громкость", value: media.volume)
                Text("Нажми кнопки громкости — значение обновится.")
                    .font(.system(size: 12))
                    .foregroundColor(VoidColor.textTertiary)
            }

            LiveSection(title: "Аудиомаршрут", api: "AVAudioSession.currentRoute.outputs") {
                InfoRow(label: "Выход", value: media.route)
                InfoRow(label: "Частота дискретизации", value: media.sampleRate)
            }

            LiveSection(title: "Синтез речи", api: "AVSpeechSynthesisVoice.speechVoices()") {
                InfoRow(label: "Доступно голосов", value: media.voices)
                actionButton("Озвучить фразу") {
                    media.speak("Привет! Это синтез речи в приложении void.")
                }
            }
        }
        .onAppear {
            media.refresh()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in media.refresh() }
        }
        .onDisappear { timer?.invalidate() }
    }

    private func actionButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button {
            Haptics.selection()
            action()
        } label: {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(VoidColor.accent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(RoundedRectangle(cornerRadius: 12).fill(VoidColor.accentSoft))
        }
        .buttonStyle(PressableStyle())
    }
}
