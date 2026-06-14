import UserNotifications

// Local notifications
enum NotificationService {
    static func scheduleDemo(completion: @escaping (String) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else {
                DispatchQueue.main.async { completion("Доступ не выдан") }
                return
            }
            let content = UNMutableNotificationContent()
            content.title = "void"
            content.body = "Локальное уведомление сработало ✦"
            content.sound = .default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request) { _ in
                DispatchQueue.main.async { completion("Уведомление через 5 секунд") }
            }
        }
    }
}
