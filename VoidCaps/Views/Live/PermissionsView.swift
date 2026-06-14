import SwiftUI

struct PermissionsView: View {
    let title: String
    private let perms = PermissionsService.shared

    @State private var camera = "—"
    @State private var mic = "—"
    @State private var photos = "—"
    @State private var location = "—"
    @State private var contacts = "—"
    @State private var calendar = "—"
    @State private var motion = "—"
    @State private var bioResult = "—"
    @State private var notifResult = "Нажми, чтобы запланировать"

    var body: some View {
        ScreenScaffold(title: title) {
            permissionRow("Камера", "AVCaptureDevice.requestAccess(.video)", camera) {
                perms.requestCamera { camera = $0 }
            }
            permissionRow("Микрофон", "AVCaptureDevice.requestAccess(.audio)", mic) {
                perms.requestMic { mic = $0 }
            }
            permissionRow("Фотогалерея", "PHPhotoLibrary.requestAuthorization", photos) {
                perms.requestPhotos { photos = $0 }
            }
            permissionRow("Геопозиция", "CLLocationManager.requestWhenInUseAuthorization", location) {
                perms.requestLocation { location = $0 }
            }
            permissionRow("Контакты", "CNContactStore.requestAccess(.contacts)", contacts) {
                perms.requestContacts { contacts = $0 }
            }
            permissionRow("Календарь", "EKEventStore.requestAccess(.event)", calendar) {
                perms.requestCalendar { calendar = $0 }
            }
            permissionRow("Движение/шаги", "CMMotionActivityManager", motion) {
                perms.requestMotion { motion = $0 }
            }

            LiveSection(title: "Биометрия", api: "LAContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)") {
                InfoRow(label: "Тип", value: BiometricsService.typeName())
                InfoRow(label: "Результат", value: bioResult)
                actionButton("Проверить \(BiometricsService.typeName())") {
                    BiometricsService.evaluate { bioResult = $0 }
                }
            }

            LiveSection(title: "Локальное уведомление", api: "UNUserNotificationCenter · UNTimeIntervalNotificationTrigger") {
                InfoRow(label: "Статус", value: notifResult)
                actionButton("Запланировать через 5 сек") {
                    NotificationService.scheduleDemo { notifResult = $0 }
                }
            }
        }
        .onAppear(perform: loadStatuses)
    }

    private func loadStatuses() {
        camera = perms.cameraStatus
        mic = perms.micStatus
        photos = perms.photosStatus
        location = perms.locationStatus
        contacts = perms.contactsStatus
        calendar = perms.calendarStatus
        motion = perms.motionStatus
        bioResult = BiometricsService.typeName()
    }

    private func permissionRow(_ label: String, _ api: String, _ status: String, action: @escaping () -> Void) -> some View {
        LiveSection(title: label, api: api) {
            InfoRow(label: "Статус", value: status)
            actionButton("Запросить доступ", action: action)
        }
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
