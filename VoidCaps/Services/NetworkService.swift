import Network
import Foundation

// NWPathMonitor connectivity
final class NetworkService: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "void.network.monitor")

    @Published var status = "—"
    @Published var interface = "—"
    @Published var expensive = false
    @Published var constrained = false

    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.status = path.status == .satisfied ? "Подключено" : "Нет сети"
                if path.usesInterfaceType(.wifi) { self?.interface = "Wi‑Fi" }
                else if path.usesInterfaceType(.cellular) { self?.interface = "Сотовая связь" }
                else if path.usesInterfaceType(.wiredEthernet) { self?.interface = "Ethernet" }
                else if path.usesInterfaceType(.loopback) { self?.interface = "Loopback" }
                else { self?.interface = "—" }
                self?.expensive = path.isExpensive
                self?.constrained = path.isConstrained
            }
        }
        monitor.start(queue: queue)
    }

    func stop() { monitor.cancel() }
}
