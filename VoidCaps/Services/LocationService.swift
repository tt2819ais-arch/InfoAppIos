import CoreLocation

// Live location + heading + reverse geocoding
final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var authorization = "Не запрошено"
    @Published var latitude = "—"
    @Published var longitude = "—"
    @Published var altitude = "—"
    @Published var speed = "—"
    @Published var course = "—"
    @Published var hAccuracy = "—"
    @Published var vAccuracy = "—"
    @Published var heading = "—"
    @Published var place = "—"

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        authorization = string(for: manager.authorizationStatus)
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        if CLLocationManager.headingAvailable() { manager.startUpdatingHeading() }
    }

    func stop() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }

    func locationManagerDidChangeAuthorization(_ m: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorization = self.string(for: m.authorizationStatus)
            if m.authorizationStatus == .authorizedWhenInUse || m.authorizationStatus == .authorizedAlways {
                m.startUpdatingLocation()
            }
        }
    }

    func locationManager(_ m: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        latitude = String(format: "%.5f°", loc.coordinate.latitude)
        longitude = String(format: "%.5f°", loc.coordinate.longitude)
        altitude = String(format: "%.0f м", loc.altitude)
        speed = loc.speed >= 0 ? String(format: "%.1f м/с", loc.speed) : "—"
        course = loc.course >= 0 ? String(format: "%.0f°", loc.course) : "—"
        hAccuracy = String(format: "±%.0f м", loc.horizontalAccuracy)
        vAccuracy = String(format: "±%.0f м", loc.verticalAccuracy)
        reverseGeocode(loc)
    }

    func locationManager(_ m: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = String(format: "%.0f° (магн.) · %.0f° (истин.)", newHeading.magneticHeading, newHeading.trueHeading)
    }

    func locationManager(_ m: CLLocationManager, didFailWithError error: Error) {}

    private var geocoding = false
    private func reverseGeocode(_ loc: CLLocation) {
        guard !geocoding else { return }
        geocoding = true
        geocoder.reverseGeocodeLocation(loc) { [weak self] marks, _ in
            self?.geocoding = false
            guard let p = marks?.first else { return }
            let parts = [p.locality, p.administrativeArea, p.country].compactMap { $0 }
            DispatchQueue.main.async { self?.place = parts.isEmpty ? "—" : parts.joined(separator: ", ") }
        }
    }

    private func string(for s: CLAuthorizationStatus) -> String {
        switch s {
        case .authorizedAlways: return "Всегда"
        case .authorizedWhenInUse: return "При использовании"
        case .denied: return "Запрещено"
        case .restricted: return "Ограничено"
        case .notDetermined: return "Не запрошено"
        @unknown default: return "—"
        }
    }
}
