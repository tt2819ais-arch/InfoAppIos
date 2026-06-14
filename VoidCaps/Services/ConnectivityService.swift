import CoreBluetooth
#if canImport(CoreNFC)
import CoreNFC
#endif

// Bluetooth state (CBCentralManager) + NFC availability
final class ConnectivityService: NSObject, ObservableObject, CBCentralManagerDelegate {
    private var central: CBCentralManager?
    @Published var bluetooth = "Не запрошено"

    func start() {
        // Initializing triggers the Bluetooth permission prompt + state callback
        central = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let s: String
        switch central.state {
        case .poweredOn: s = "Включён"
        case .poweredOff: s = "Выключен"
        case .unauthorized: s = "Нет доступа"
        case .unsupported: s = "Не поддерживается"
        case .resetting: s = "Сброс…"
        case .unknown: s = "Неизвестно"
        @unknown default: s = "—"
        }
        DispatchQueue.main.async { self.bluetooth = s }
    }

    var nfcAvailable: String {
        #if canImport(CoreNFC)
        return NFCNDEFReaderSession.readingAvailable ? "Доступно (нужна подпись)" : "Недоступно"
        #else
        return "Недоступно"
        #endif
    }
}
