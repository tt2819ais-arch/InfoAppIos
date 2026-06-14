import SwiftUI

struct TorchView: View {
    let title: String
    @StateObject private var torch = TorchService()

    var body: some View {
        ScreenScaffold(title: title) {
            LiveSection(title: "Фонарик", api: "device.torchMode = .on / .off") {
                if torch.hasTorch {
                    Toggle(isOn: Binding(
                        get: { torch.isOn },
                        set: { torch.setOn($0, level: torch.level) })) {
                        Text(torch.isOn ? "Включён" : "Выключен")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(VoidColor.textPrimary)
                    }
                    .tint(VoidColor.accent)
                } else {
                    Text("Фонарик недоступен на этом устройстве")
                        .font(.system(size: 13))
                        .foregroundColor(VoidColor.textSecondary)
                }
            }

            LiveSection(title: "Уровень яркости", api: "device.setTorchModeOn(level:)") {
                HStack {
                    Image(systemName: "flashlight.off.fill").foregroundColor(VoidColor.textTertiary)
                    Slider(value: Binding(
                        get: { Double(torch.level) },
                        set: { v in
                            torch.level = Float(v)
                            if torch.isOn { torch.setOn(true, level: Float(v)) }
                        }), in: 0.05...1.0)
                    .tint(VoidColor.accent)
                    Image(systemName: "flashlight.on.fill").foregroundColor(VoidColor.accent)
                }
                InfoRow(label: "Текущий уровень", value: "\(Int(torch.level * 100))%")
            }
        }
        .onDisappear { torch.setOn(false, level: torch.level) }
    }
}
