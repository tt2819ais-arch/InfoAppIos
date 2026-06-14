import SwiftUI

struct SecurityView: View {
    let title: String
    @State private var bioResult = "—"
    @State private var authResult = "—"
    @State private var keychainResult = "—"

    var body: some View {
        ScreenScaffold(title: title) {
            LiveSection(title: "Биометрия", api: "LAContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)") {
                InfoRow(label: "Тип", value: BiometricsService.typeName())
                InfoRow(label: "Результат", value: bioResult)
                actionButton("Проверить \(BiometricsService.typeName())") {
                    BiometricsService.evaluate { bioResult = $0 }
                }
            }

            LiveSection(title: "Код-пароль", api: "LAContext.canEvaluatePolicy(.deviceOwnerAuthentication)") {
                InfoRow(label: "Код установлен", value: SecurityService.passcodeSet())
                InfoRow(label: "Результат", value: authResult)
                actionButton("Аутентификация (код/биометрия)") {
                    SecurityService.authenticate { authResult = $0 }
                }
            }

            LiveSection(title: "Keychain (Secure Enclave)", api: "SecItemAdd · SecItemCopyMatching") {
                InfoRow(label: "Состояние", value: keychainResult)
                actionButton("Сохранить секрет в Keychain") {
                    keychainResult = SecurityService.keychainStore("void-secret-\(Int.random(in: 1000...9999))")
                }
                actionButton("Прочитать секрет") {
                    keychainResult = SecurityService.keychainRead()
                }
                Text("kSecAttrAccessibleWhenUnlockedThisDeviceOnly — данные хранятся под защитой Secure Enclave.")
                    .font(.system(size: 12))
                    .foregroundColor(VoidColor.textTertiary)
            }
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
