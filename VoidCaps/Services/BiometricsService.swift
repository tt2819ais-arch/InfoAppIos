import LocalAuthentication

// Face ID / Touch ID
enum BiometricsService {
    static func typeName() -> String {
        let ctx = LAContext()
        _ = ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch ctx.biometryType {
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        case .opticID: return "Optic ID"
        default: return "Недоступно"
        }
    }

    static func evaluate(completion: @escaping (String) -> Void) {
        let ctx = LAContext()
        var error: NSError?
        guard ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion("Недоступно: \(error?.localizedDescription ?? "—")")
            return
        }
        ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                           localizedReason: "Подтвердите личность для демонстрации") { success, err in
            DispatchQueue.main.async {
                if success { completion("Успешно ✓") }
                else { completion("Отклонено: \(err?.localizedDescription ?? "—")") }
            }
        }
    }
}
