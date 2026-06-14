import UIKit

// Clipboard, share sheet, settings, URL open
enum MiscService {
    static func copy(_ text: String) {
        UIPasteboard.general.string = text
    }

    static func pasteboardContents() -> String {
        UIPasteboard.general.string ?? "пусто"
    }

    static func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    static func open(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    static func topViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
        var top = windowScene?.windows.first(where: { $0.isKeyWindow })?.rootViewController
        while let presented = top?.presentedViewController { top = presented }
        return top
    }

    static func share(_ items: [Any]) {
        guard let top = topViewController() else { return }
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let pop = vc.popoverPresentationController {
            pop.sourceView = top.view
            pop.sourceRect = CGRect(x: top.view.bounds.midX, y: top.view.bounds.midY, width: 0, height: 0)
            pop.permittedArrowDirections = []
        }
        top.present(vc, animated: true)
    }

    static func setProximityMonitoring(_ on: Bool) {
        UIDevice.current.isProximityMonitoringEnabled = on
    }
}
