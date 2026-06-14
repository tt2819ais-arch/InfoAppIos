import LocalAuthentication
import Security
import Foundation

// Passcode check + Keychain store/read demo
enum SecurityService {
    // Whether a device passcode is set
    static func passcodeSet() -> String {
        let ctx = LAContext()
        var error: NSError?
        let ok = ctx.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        return ok ? "Установлен" : "Не установлен / недоступно"
    }

    // Authenticate with passcode OR biometrics
    static func authenticate(completion: @escaping (String) -> Void) {
        let ctx = LAContext()
        var error: NSError?
        guard ctx.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            completion("Недоступно: \(error?.localizedDescription ?? "—")"); return
        }
        ctx.evaluatePolicy(.deviceOwnerAuthentication,
                           localizedReason: "Подтвердите личность (код или биометрия)") { ok, err in
            DispatchQueue.main.async {
                completion(ok ? "Успешно ✓" : "Отклонено: \(err?.localizedDescription ?? "—")")
            }
        }
    }

    private static let account = "void.demo.secret"
    private static let service = "void.keychain.demo"

    // Store a secret string in the Keychain
    static func keychainStore(_ value: String) -> String {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
        var add = query
        add[kSecValueData as String] = data
        add[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        let status = SecItemAdd(add as CFDictionary, nil)
        return status == errSecSuccess ? "Сохранено в Keychain ✓" : "Ошибка \(status)"
    }

    // Read it back
    static func keychainRead() -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess, let data = item as? Data, let s = String(data: data, encoding: .utf8) {
            return "Из Keychain: \(s)"
        }
        return status == errSecItemNotFound ? "Сначала сохрани секрет" : "Ошибка \(status)"
    }
}
