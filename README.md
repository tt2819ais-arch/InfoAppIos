# void — каталог возможностей iPhone

Минималистичное SwiftUI‑приложение в оформлении **void** (near‑black, лавандовый акцент),
демонстрирующее функции, которые приложение может вызвать на iPhone. Нажми на функцию —
она срабатывает (вибрация, звук, фонарик…), после чего показывается её точное системное имя
(API) моноширинным шрифтом и краткое описание.

## Категории
- **Вибрация и тактильность** — UIImpactFeedbackGenerator (.light/.medium/.heavy/.soft/.rigid),
  UINotificationFeedbackGenerator (.success/.warning/.error), UISelectionFeedbackGenerator,
  AudioServices vibrate + классические ID 1519/1520/1521.
- **Системные звуки** — AudioServicesPlaySystemSound с подборкой известных ID (Tink 1057, Tock 1103 и др.).
- **Core Haptics** — кастомные паттерны CHHapticEngine (transient/continuous, intensity/sharpness, составной паттерн).
- **Фонарик** — AVCaptureDevice torchMode + setTorchModeOn(level:).
- **Экран** — UIScreen.brightness, isIdleTimerDisabled, детектор скриншота/записи (isCaptured).
- **Датчики движения** — CMMotionManager (акселерометр, гироскоп, магнитометр, attitude), CMPedometer.
- **Об устройстве** — UIDevice, ProcessInfo (батарея, температура, ОЗУ, аптайм), хранилище.
- **Сеть** — NWPathMonitor (статус, тип интерфейса, expensive/constrained).
- **Доступы и разрешения** — камера, микрофон, фото, гео, контакты, календарь, движение,
  Face ID/Touch ID (LAContext), локальные уведомления (UNUserNotificationCenter).
- **Действия системы** — синтез речи (AVSpeechSynthesizer), буфер обмена (UIPasteboard),
  «Поделиться» (UIActivityViewController), датчик приближения, открыть Настройки/ссылку.

## Сборка
Проект использует **XcodeGen** (`project.yml`) — `.xcodeproj` генерируется в CI, не хранится в репозитории.

```
brew install xcodegen
xcodegen generate
open VoidCaps.xcodeproj
```

- Bundle ID: `com.void.capabilities` · Scheme/Target: `VoidCaps` · iOS 16.0+

## Сборка .ipa (GitHub Actions)
Готовый workflow — `ci/ios-ipa.yml.txt`. Его нужно добавить вручную как
`.github/workflows/ios-ipa.yml` через веб‑интерфейс GitHub (GitHub App не может пушить файлы
в `.github/workflows/`). Workflow собирает **неподписанный** `.ipa` на `macos-latest` и выкладывает
артефакт `VoidCaps-ipa-unsigned`. Устанавливать через Esign / AltStore / Sideloadly.
