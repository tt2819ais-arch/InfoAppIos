import Foundation
import CoreTelephony

// Local + public IP, carrier / radio info
final class IPService: ObservableObject {
    @Published var wifiIP = "—"
    @Published var cellularIP = "—"
    @Published var allInterfaces: [String] = []
    @Published var publicIP = "загрузка…"
    @Published var carrier = "—"
    @Published var radio = "—"

    private let netInfo = CTTelephonyNetworkInfo()

    func refresh() {
        readLocalIPs()
        readCarrier()
        fetchPublicIP()
    }

    // getifaddrs — enumerate all interface IPv4 addresses
    func readLocalIPs() {
        var wifi = "—", cell = "—"
        var list: [String] = []
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let first = ifaddr else { return }
        var ptr: UnsafeMutablePointer<ifaddrs>? = first
        let up = UInt32(IFF_UP), running = UInt32(IFF_RUNNING)
        while let cur = ptr {
            let flags = cur.pointee.ifa_flags
            let addr = cur.pointee.ifa_addr
            if (flags & (up | running)) == (up | running),
               let addr = addr, addr.pointee.sa_family == UInt8(AF_INET) {
                let name = String(cString: cur.pointee.ifa_name)
                var host = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(addr, socklen_t(addr.pointee.sa_len), &host, socklen_t(host.count),
                            nil, 0, NI_NUMERICHOST)
                let ip = String(cString: host)
                if !ip.isEmpty {
                    list.append("\(name): \(ip)")
                    if name == "en0" { wifi = ip }
                    if name.hasPrefix("pdp_ip") { cell = ip }
                }
            }
            ptr = cur.pointee.ifa_next
        }
        freeifaddrs(ifaddr)
        DispatchQueue.main.async {
            self.wifiIP = wifi; self.cellularIP = cell; self.allInterfaces = list
        }
    }

    func readCarrier() {
        var name = "—"
        if let providers = netInfo.serviceSubscriberCellularProviders, let c = providers.values.first {
            name = c.carrierName ?? "—"
        }
        var rat = "—"
        if let techs = netInfo.serviceCurrentRadioAccessTechnology, let t = techs.values.first {
            rat = Self.radioName(t)
        }
        DispatchQueue.main.async { self.carrier = name; self.radio = rat }
    }

    static func radioName(_ raw: String) -> String {
        let map: [String: String] = [
            CTRadioAccessTechnologyGPRS: "GPRS (2G)",
            CTRadioAccessTechnologyEdge: "EDGE (2G)",
            CTRadioAccessTechnologyWCDMA: "WCDMA (3G)",
            CTRadioAccessTechnologyHSDPA: "HSDPA (3G)",
            CTRadioAccessTechnologyHSUPA: "HSUPA (3G)",
            CTRadioAccessTechnologyCDMA1x: "CDMA 1x",
            CTRadioAccessTechnologyLTE: "LTE (4G)",
            CTRadioAccessTechnologyNRNSA: "5G NSA",
            CTRadioAccessTechnologyNR: "5G NR"
        ]
        return map[raw] ?? raw.replacingOccurrences(of: "CTRadioAccessTechnology", with: "")
    }

    func fetchPublicIP() {
        guard let url = URL(string: "https://api.ipify.org") else { return }
        var req = URLRequest(url: url)
        req.timeoutInterval = 8
        URLSession.shared.dataTask(with: req) { data, _, err in
            let result: String
            if let data = data, let ip = String(data: data, encoding: .utf8), !ip.isEmpty, err == nil {
                result = ip.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                result = "недоступно"
            }
            DispatchQueue.main.async { self.publicIP = result }
        }.resume()
    }
}
