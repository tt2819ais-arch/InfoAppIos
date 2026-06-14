import UIKit
import AudioToolbox

// The full catalog of demonstrated iPhone capabilities
enum Catalog {
    static var categories: [CapabilityCategory] {
        [haptics, sounds, coreHaptics, torch, screen, motion, device, network, permissions, actions]
    }

    // MARK: 1. Haptics / vibration
    static let haptics = CapabilityCategory(
        title: "Вибрация и тактильность",
        subtitle: "Все виды отдачи UIKit",
        icon: "waveform.path",
        kind: .actions([
            Capability(title: "Лёгкий удар", api: "UIImpactFeedbackGenerator(style: .light)",
                       detail: "Слабая тактильная отдача", icon: "circle",
                       action: { Haptics.impact(.light) }),
            Capability(title: "Средний удар", api: "UIImpactFeedbackGenerator(style: .medium)",
                       detail: "Средняя тактильная отдача", icon: "circle.fill",
                       action: { Haptics.impact(.medium) }),
            Capability(title: "Сильный удар", api: "UIImpactFeedbackGenerator(style: .heavy)",
                       detail: "Сильная тактильная отдача", icon: "circle.circle.fill",
                       action: { Haptics.impact(.heavy) }),
            Capability(title: "Мягкий удар", api: "UIImpactFeedbackGenerator(style: .soft)",
                       detail: "Плавная мягкая отдача", icon: "drop",
                       action: { Haptics.impact(.soft) }),
            Capability(title: "Жёсткий удар", api: "UIImpactFeedbackGenerator(style: .rigid)",
                       detail: "Резкая жёсткая отдача", icon: "square",
                       action: { Haptics.impact(.rigid) }),
            Capability(title: "Успех", api: "UINotificationFeedbackGenerator(.success)",
                       detail: "Уведомление об успехе", icon: "checkmark.circle",
                       action: { Haptics.notification(.success) }),
            Capability(title: "Предупреждение", api: "UINotificationFeedbackGenerator(.warning)",
                       detail: "Уведомление‑предупреждение", icon: "exclamationmark.triangle",
                       action: { Haptics.notification(.warning) }),
            Capability(title: "Ошибка", api: "UINotificationFeedbackGenerator(.error)",
                       detail: "Уведомление об ошибке", icon: "xmark.octagon",
                       action: { Haptics.notification(.error) }),
            Capability(title: "Выбор", api: "UISelectionFeedbackGenerator().selectionChanged()",
                       detail: "Отдача при переключении", icon: "slider.horizontal.3",
                       action: { Haptics.selection() }),
            Capability(title: "Системная вибрация", api: "AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)",
                       detail: "Классическая вибрация (ID 4095)", icon: "iphone.radiowaves.left.and.right",
                       action: { SystemSounds.vibrate() }),
            Capability(title: "Peek", api: "AudioServicesPlaySystemSound(1519)",
                       detail: "Короткая слабая вибрация", icon: "1.circle",
                       action: { SystemSounds.play(1519) }),
            Capability(title: "Pop", api: "AudioServicesPlaySystemSound(1520)",
                       detail: "Сильная одиночная вибрация", icon: "2.circle",
                       action: { SystemSounds.play(1520) }),
            Capability(title: "Nope", api: "AudioServicesPlaySystemSound(1521)",
                       detail: "Тройная слабая вибрация", icon: "3.circle",
                       action: { SystemSounds.play(1521) }),
        ]))

    // MARK: 2. System sounds
    static let sounds = CapabilityCategory(
        title: "Системные звуки",
        subtitle: "Встроенные звуки iOS по ID",
        icon: "speaker.wave.2",
        kind: .actions(soundList.map { item in
            Capability(title: item.name, api: "AudioServicesPlaySystemSound(\(item.id))",
                       detail: "Системный звук #\(item.id)", icon: "speaker.wave.1",
                       action: { SystemSounds.play(item.id) })
        }))

    static let soundList: [(name: String, id: SystemSoundID)] = [
        ("Tink", 1057), ("Tock", 1103), ("Tock (клавиша)", 1104),
        ("Новое письмо", 1000), ("Письмо отправлено", 1001), ("Голосовая почта", 1003),
        ("Сообщение получено", 1005), ("SMS (Tri‑tone)", 1007), ("SMS (Chime)", 1013),
        ("Твит отправлен", 1016), ("Затвор камеры", 1108), ("Начало записи", 1117),
        ("Подтверждение", 1118), ("Отмена", 1119), ("Anticipate", 1020),
        ("Оплата прошла", 1322), ("USB подключён", 1054), ("Низкий заряд", 1006),
    ]

    // MARK: 3. Core Haptics
    static let coreHaptics = CapabilityCategory(
        title: "Core Haptics",
        subtitle: "Кастомные тактильные паттерны",
        icon: "waveform.path.ecg",
        kind: .actions([
            Capability(title: "Мягкий импульс", api: "CHHapticEvent(.hapticTransient) intensity 0.4 / sharpness 0.2",
                       detail: "Одиночный мягкий импульс", icon: "dot.radiowaves.left.and.right",
                       action: { HapticEngineManager.shared.transient(intensity: 0.4, sharpness: 0.2) }),
            Capability(title: "Резкий импульс", api: "CHHapticEvent(.hapticTransient) intensity 1.0 / sharpness 1.0",
                       detail: "Острый сильный импульс", icon: "bolt",
                       action: { HapticEngineManager.shared.transient(intensity: 1.0, sharpness: 1.0) }),
            Capability(title: "Непрерывный гул", api: "CHHapticEvent(.hapticContinuous) duration 0.6",
                       detail: "Длительная непрерывная вибрация", icon: "waveform",
                       action: { HapticEngineManager.shared.continuous(intensity: 0.8, sharpness: 0.5, duration: 0.6) }),
            Capability(title: "Сердцебиение", api: "CHHapticPattern([transient, transient, continuous])",
                       detail: "Составной паттерн из событий", icon: "heart.fill",
                       action: { HapticEngineManager.shared.heartbeat() }),
        ]))

    // MARK: Live screens
    static let torch = CapabilityCategory(
        title: "Фонарик", subtitle: "Вспышка и уровень яркости",
        icon: "flashlight.on.fill", kind: .live(.torch))
    static let screen = CapabilityCategory(
        title: "Экран", subtitle: "Яркость, автоблок, запись",
        icon: "sun.max", kind: .live(.screen))
    static let motion = CapabilityCategory(
        title: "Датчики движения", subtitle: "Акселерометр, гироскоп, шаги",
        icon: "gyroscope", kind: .live(.motion))
    static let device = CapabilityCategory(
        title: "Об устройстве", subtitle: "Батарея, память, система",
        icon: "iphone", kind: .live(.device))
    static let network = CapabilityCategory(
        title: "Сеть", subtitle: "Тип подключения и статус",
        icon: "wifi", kind: .live(.network))
    static let permissions = CapabilityCategory(
        title: "Доступы и разрешения", subtitle: "Камера, гео, Face ID, уведомления",
        icon: "lock.shield", kind: .live(.permissions))

    // MARK: Misc actions
    static let actions = CapabilityCategory(
        title: "Действия системы",
        subtitle: "Буфер, озвучка, поделиться и др.",
        icon: "square.grid.2x2",
        kind: .actions([
            Capability(title: "Озвучить текст", api: "AVSpeechSynthesizer().speak(utterance)",
                       detail: "Синтез речи (text‑to‑speech)", icon: "text.bubble",
                       action: { SpeechService.shared.speak("Привет! Это демонстрация синтеза речи на айфоне.") }),
            Capability(title: "Скопировать в буфер", api: "UIPasteboard.general.string = …",
                       detail: "Текст скопирован в буфер обмена", icon: "doc.on.doc",
                       action: { MiscService.copy("void · демонстрация буфера обмена") }),
            Capability(title: "Прочитать буфер", api: "UIPasteboard.general.string",
                       detail: "Содержимое буфера обмена", icon: "doc.on.clipboard",
                       action: { }, dynamicResult: { "В буфере: \(MiscService.pasteboardContents())" }),
            Capability(title: "Поделиться", api: "UIActivityViewController(activityItems:)",
                       detail: "Системное окно «Поделиться»", icon: "square.and.arrow.up",
                       action: { MiscService.share(["void — каталог возможностей iPhone"]) }),
            Capability(title: "Датчик приближения вкл", api: "UIDevice.isProximityMonitoringEnabled = true",
                       detail: "Гасит экран у уха", icon: "sensor.tag.radiowaves.forward",
                       action: { MiscService.setProximityMonitoring(true) },
                       dynamicResult: { "Мониторинг приближения: включён" }),
            Capability(title: "Датчик приближения выкл", api: "UIDevice.isProximityMonitoringEnabled = false",
                       detail: "Отключает датчик приближения", icon: "sensor.tag.radiowaves.forward.fill",
                       action: { MiscService.setProximityMonitoring(false) },
                       dynamicResult: { "Мониторинг приближения: выключен" }),
            Capability(title: "Открыть Настройки", api: "UIApplication.openSettingsURLString",
                       detail: "Переход в системные настройки", icon: "gearshape",
                       action: { MiscService.openSettings() }),
            Capability(title: "Открыть ссылку", api: "UIApplication.shared.open(URL)",
                       detail: "Открывает Safari по ссылке", icon: "safari",
                       action: { MiscService.open("https://www.apple.com/ru/ios/") }),
        ]))
}
