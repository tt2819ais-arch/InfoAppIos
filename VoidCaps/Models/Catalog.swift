import UIKit
import AudioToolbox

// The full catalog of demonstrated iPhone capabilities
enum Catalog {
    static var categories: [CapabilityCategory] {
        [haptics, coreHaptics, sounds, torch, screen, motion, location,
         device, network, connectivity, security, media, permissions, actions]
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

    // MARK: 2. Core Haptics
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
            Capability(title: "Двойной тап", api: "CHHapticPattern([transient ×2])",
                       detail: "Два быстрых импульса", icon: "hand.tap",
                       action: { HapticEngineManager.shared.taps(count: 2) }),
            Capability(title: "Тройной тап", api: "CHHapticPattern([transient ×3])",
                       detail: "Три быстрых импульса", icon: "hand.tap.fill",
                       action: { HapticEngineManager.shared.taps(count: 3) }),
            Capability(title: "Непрерывный гул", api: "CHHapticEvent(.hapticContinuous) duration 0.6",
                       detail: "Длительная непрерывная вибрация", icon: "waveform",
                       action: { HapticEngineManager.shared.continuous(intensity: 0.8, sharpness: 0.5, duration: 0.6) }),
            Capability(title: "Нарастание", api: "CHHapticParameterCurve(.hapticIntensityControl)",
                       detail: "Плавно растущая интенсивность", icon: "chart.line.uptrend.xyaxis",
                       action: { HapticEngineManager.shared.crescendo() }),
            Capability(title: "Сердцебиение", api: "CHHapticPattern([transient, transient, continuous])",
                       detail: "Составной паттерн из событий", icon: "heart.fill",
                       action: { HapticEngineManager.shared.heartbeat() }),
            Capability(title: "SOS (Морзе)", api: "CHHapticPattern · · · — — — · · ·",
                       detail: "Сигнал бедствия азбукой Морзе", icon: "dot.radiowaves.up.forward",
                       action: { HapticEngineManager.shared.sos() }),
        ]))

    // MARK: 3. System sounds
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
        ("Tink", 1057), ("Tock", 1103), ("Tock (клавиша)", 1104), ("Удаление клавиши", 1155),
        ("Новое письмо", 1000), ("Письмо отправлено", 1001), ("Голосовая почта", 1003),
        ("Сообщение получено", 1005), ("SMS · Tri‑tone", 1007), ("SMS · Chime", 1008),
        ("SMS · Glass", 1009), ("SMS · Horn", 1010), ("SMS · Bell", 1011), ("SMS · Electronic", 1012),
        ("Твит отправлен", 1016), ("Anticipate", 1020), ("Bloom", 1021), ("Calypso", 1022),
        ("Choo Choo", 1023), ("Descent", 1024), ("Fanfare", 1025), ("Ladder", 1026),
        ("Minuet", 1027), ("News Flash", 1028), ("Noir", 1029), ("Sherwood Forest", 1030),
        ("Spell", 1031), ("Suspense", 1032), ("Telegraph", 1033), ("Tiptoes", 1034),
        ("Typewriters", 1035), ("Update", 1036), ("Затвор камеры", 1108), ("Блокировка", 1100),
        ("Начало записи", 1113), ("Конец записи", 1114), ("USB подключён", 1054),
        ("Зарядка началась", 1106), ("Низкий заряд", 1006), ("Оплата прошла", 1394),
    ]

    // MARK: Live screens
    static let torch = CapabilityCategory(
        title: "Фонарик", subtitle: "Вспышка и уровень яркости",
        icon: "flashlight.on.fill", kind: .live(.torch))
    static let screen = CapabilityCategory(
        title: "Экран", subtitle: "Яркость, частота, автоблок, запись",
        icon: "sun.max", kind: .live(.screen))
    static let motion = CapabilityCategory(
        title: "Датчики движения", subtitle: "Акселерометр, гироскоп, барометр, шаги",
        icon: "gyroscope", kind: .live(.motion))
    static let location = CapabilityCategory(
        title: "Геолокация", subtitle: "Координаты, компас, геокодинг",
        icon: "location.fill", kind: .live(.location))
    static let device = CapabilityCategory(
        title: "Об устройстве", subtitle: "Батарея, память, дисплей, регион",
        icon: "iphone", kind: .live(.device))
    static let network = CapabilityCategory(
        title: "Сеть и IP", subtitle: "IP‑адреса, оператор, тип подключения",
        icon: "wifi", kind: .live(.network))
    static let connectivity = CapabilityCategory(
        title: "Bluetooth и NFC", subtitle: "Состояние радиомодулей",
        icon: "dot.radiowaves.right", kind: .live(.connectivity))
    static let security = CapabilityCategory(
        title: "Безопасность", subtitle: "Face ID, код‑пароль, Keychain",
        icon: "lock.shield", kind: .live(.security))
    static let media = CapabilityCategory(
        title: "Аудио и медиа", subtitle: "Громкость, маршрут, синтез речи",
        icon: "speaker.wave.3", kind: .live(.media))
    static let permissions = CapabilityCategory(
        title: "Доступы и разрешения", subtitle: "Камера, гео, трекинг, здоровье",
        icon: "checkmark.shield", kind: .live(.permissions))

    // MARK: Misc actions
    static let actions = CapabilityCategory(
        title: "Действия системы",
        subtitle: "Буфер, поделиться, иконка, оценка",
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
            Capability(title: "Сменить иконку", api: "UIApplication.setAlternateIconName(\"AltIconLight\")",
                       detail: "Альтернативная иконка приложения", icon: "app.badge",
                       action: { MiscService.setAlternateIcon("AltIconLight") { _ in } },
                       dynamicResult: { "Иконка приложения переключена — посмотри на рабочем столе" }),
            Capability(title: "Вернуть иконку", api: "UIApplication.setAlternateIconName(nil)",
                       detail: "Сброс на основную иконку", icon: "app",
                       action: { MiscService.setAlternateIcon(nil) { _ in } },
                       dynamicResult: { "Иконка сброшена на основную" }),
            Capability(title: "Оценить приложение", api: "SKStoreReviewController.requestReview(in:)",
                       detail: "Системное окно оценки", icon: "star.bubble",
                       action: { MiscService.requestReview() }),
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
            Capability(title: "Открыть карты", api: "UIApplication.shared.open(maps://)",
                       detail: "Запуск Apple Maps по координате", icon: "map",
                       action: { MiscService.open("http://maps.apple.com/?ll=55.7558,37.6173") }),
            Capability(title: "Написать письмо", api: "UIApplication.shared.open(mailto:)",
                       detail: "Запуск Почты с черновиком", icon: "envelope",
                       action: { MiscService.open("mailto:?subject=void&body=Привет из void") }),
            Capability(title: "Открыть ссылку", api: "UIApplication.shared.open(URL)",
                       detail: "Открывает Safari по ссылке", icon: "safari",
                       action: { MiscService.open("https://www.apple.com/ru/ios/") }),
        ]))
}
