import AVFoundation
import Photos
import CoreLocation
import Contacts
import EventKit
import CoreMotion
import UserNotifications

// Authorization requests + status strings
final class PermissionsService: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = PermissionsService()
    private let location = CLLocationManager()

    override init() {
        super.init()
        location.delegate = self
    }

    // MARK: Camera
    func requestCamera(_ done: @escaping (String) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { ok in
            DispatchQueue.main.async { done(ok ? "Разрешено" : "Отклонено") }
        }
    }
    var cameraStatus: String { authString(AVCaptureDevice.authorizationStatus(for: .video)) }

    // MARK: Microphone
    func requestMic(_ done: @escaping (String) -> Void) {
        AVCaptureDevice.requestAccess(for: .audio) { ok in
            DispatchQueue.main.async { done(ok ? "Разрешено" : "Отклонено") }
        }
    }
    var micStatus: String { authString(AVCaptureDevice.authorizationStatus(for: .audio)) }

    // MARK: Photos
    func requestPhotos(_ done: @escaping (String) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { st in
            DispatchQueue.main.async { done(self.photoString(st)) }
        }
    }
    var photosStatus: String { photoString(PHPhotoLibrary.authorizationStatus(for: .readWrite)) }

    // MARK: Location
    private var locationDone: ((String) -> Void)?
    func requestLocation(_ done: @escaping (String) -> Void) {
        locationDone = done
        location.requestWhenInUseAuthorization()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let s = locationString(manager.authorizationStatus)
        DispatchQueue.main.async { self.locationDone?(s) }
    }
    var locationStatus: String { locationString(location.authorizationStatus) }

    // MARK: Contacts
    func requestContacts(_ done: @escaping (String) -> Void) {
        CNContactStore().requestAccess(for: .contacts) { ok, _ in
            DispatchQueue.main.async { done(ok ? "Разрешено" : "Отклонено") }
        }
    }
    var contactsStatus: String { authString(CNContactStore.authorizationStatus(for: .contacts)) }

    // MARK: Calendar
    func requestCalendar(_ done: @escaping (String) -> Void) {
        EKEventStore().requestAccess(to: .event) { ok, _ in
            DispatchQueue.main.async { done(ok ? "Разрешено" : "Отклонено") }
        }
    }
    var calendarStatus: String { authString(EKEventStore.authorizationStatus(for: .event)) }

    // MARK: Notifications
    func requestNotifications(_ done: @escaping (String) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { ok, _ in
            DispatchQueue.main.async { done(ok ? "Разрешено" : "Отклонено") }
        }
    }

    // MARK: Motion
    private let activity = CMMotionActivityManager()
    func requestMotion(_ done: @escaping (String) -> Void) {
        guard CMMotionActivityManager.isActivityAvailable() else { done("Недоступно"); return }
        activity.queryActivityStarting(from: Date().addingTimeInterval(-60), to: Date(), to: .main) { _, _ in
            done(self.motionString(CMMotionActivityManager.authorizationStatus()))
        }
    }
    var motionStatus: String { motionString(CMMotionActivityManager.authorizationStatus()) }

    // MARK: Helpers
    private func authString(_ s: AVAuthorizationStatus) -> String {
        switch s {
        case .authorized: return "Разрешено"
        case .denied: return "Запрещено"
        case .restricted: return "Ограничено"
        case .notDetermined: return "Не запрошено"
        @unknown default: return "—"
        }
    }
    private func authString(_ s: CNAuthorizationStatus) -> String {
        switch s {
        case .authorized: return "Разрешено"
        case .denied: return "Запрещено"
        case .restricted: return "Ограничено"
        case .notDetermined: return "Не запрошено"
        @unknown default: return "—"
        }
    }
    private func authString(_ s: EKAuthorizationStatus) -> String {
        switch s {
        case .authorized, .fullAccess: return "Разрешено"
        case .denied: return "Запрещено"
        case .restricted: return "Ограничено"
        case .notDetermined: return "Не запрошено"
        case .writeOnly: return "Только запись"
        @unknown default: return "—"
        }
    }
    private func photoString(_ s: PHAuthorizationStatus) -> String {
        switch s {
        case .authorized: return "Разрешено"
        case .limited: return "Ограниченный доступ"
        case .denied: return "Запрещено"
        case .restricted: return "Ограничено"
        case .notDetermined: return "Не запрошено"
        @unknown default: return "—"
        }
    }
    private func locationString(_ s: CLAuthorizationStatus) -> String {
        switch s {
        case .authorizedAlways: return "Всегда"
        case .authorizedWhenInUse: return "При использовании"
        case .denied: return "Запрещено"
        case .restricted: return "Ограничено"
        case .notDetermined: return "Не запрошено"
        @unknown default: return "—"
        }
    }
    private func motionString(_ s: CMAuthorizationStatus) -> String {
        switch s {
        case .authorized: return "Разрешено"
        case .denied: return "Запрещено"
        case .restricted: return "Ограничено"
        case .notDetermined: return "Не запрошено"
        @unknown default: return "—"
        }
    }
}
