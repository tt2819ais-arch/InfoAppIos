import CoreMotion
import Foundation

// Live sensor readouts — accelerometer, gyro, magnetometer, device motion,
// gravity, user acceleration, rotation rate, quaternion, altimeter, activity, pedometer
final class MotionService: ObservableObject {
    private let manager = CMMotionManager()
    private let pedometer = CMPedometer()
    private let altimeter = CMAltimeter()
    private let activityManager = CMMotionActivityManager()

    struct SIMDLike { var x = 0.0; var y = 0.0; var z = 0.0 }

    @Published var accel = SIMDLike()
    @Published var gyro = SIMDLike()
    @Published var mag = SIMDLike()
    @Published var gravity = SIMDLike()
    @Published var userAccel = SIMDLike()
    @Published var rotationRate = SIMDLike()
    @Published var roll = 0.0
    @Published var pitch = 0.0
    @Published var yaw = 0.0
    @Published var quaternion = "—"
    @Published var steps: Int? = nil
    @Published var distance = "—"
    @Published var floorsUp = "—"
    @Published var pace = "—"
    @Published var cadence = "—"
    @Published var pressure = "—"
    @Published var relativeAltitude = "—"
    @Published var activity = "—"
    @Published var running = false

    var accelAvailable: Bool { manager.isAccelerometerAvailable }
    var gyroAvailable: Bool { manager.isGyroAvailable }
    var magAvailable: Bool { manager.isMagnetometerAvailable }
    var motionAvailable: Bool { manager.isDeviceMotionAvailable }
    var pedometerAvailable: Bool { CMPedometer.isStepCountingAvailable() }
    var altimeterAvailable: Bool { CMAltimeter.isRelativeAltitudeAvailable() }
    var activityAvailable: Bool { CMMotionActivityManager.isActivityAvailable() }

    func start() {
        running = true
        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = 1.0 / 30.0
            manager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
                guard let d = data else { return }
                self?.accel = SIMDLike(x: d.acceleration.x, y: d.acceleration.y, z: d.acceleration.z)
            }
        }
        if manager.isGyroAvailable {
            manager.gyroUpdateInterval = 1.0 / 30.0
            manager.startGyroUpdates(to: .main) { [weak self] data, _ in
                guard let d = data else { return }
                self?.gyro = SIMDLike(x: d.rotationRate.x, y: d.rotationRate.y, z: d.rotationRate.z)
            }
        }
        if manager.isMagnetometerAvailable {
            manager.magnetometerUpdateInterval = 1.0 / 15.0
            manager.startMagnetometerUpdates(to: .main) { [weak self] data, _ in
                guard let d = data else { return }
                self?.mag = SIMDLike(x: d.magneticField.x, y: d.magneticField.y, z: d.magneticField.z)
            }
        }
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 1.0 / 30.0
            manager.startDeviceMotionUpdates(to: .main) { [weak self] data, _ in
                guard let d = data else { return }
                let a = d.attitude
                self?.roll = a.roll; self?.pitch = a.pitch; self?.yaw = a.yaw
                let q = a.quaternion
                self?.quaternion = String(format: "w%.2f x%.2f y%.2f z%.2f", q.w, q.x, q.y, q.z)
                self?.gravity = SIMDLike(x: d.gravity.x, y: d.gravity.y, z: d.gravity.z)
                self?.userAccel = SIMDLike(x: d.userAcceleration.x, y: d.userAcceleration.y, z: d.userAcceleration.z)
                self?.rotationRate = SIMDLike(x: d.rotationRate.x, y: d.rotationRate.y, z: d.rotationRate.z)
            }
        }
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Calendar.current.startOfDay(for: Date())) { [weak self] data, _ in
                guard let d = data else { return }
                DispatchQueue.main.async {
                    self?.steps = d.numberOfSteps.intValue
                    if let dist = d.distance { self?.distance = String(format: "%.0f м", dist.doubleValue) }
                    if let f = d.floorsAscended { self?.floorsUp = "\(f.intValue)" }
                    if let p = d.currentPace { self?.pace = String(format: "%.1f с/м", p.doubleValue) }
                    if let c = d.currentCadence { self?.cadence = String(format: "%.1f шаг/с", c.doubleValue) }
                }
            }
        }
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: .main) { [weak self] data, _ in
                guard let d = data else { return }
                self?.pressure = String(format: "%.2f кПа", d.pressure.doubleValue)
                self?.relativeAltitude = String(format: "%+.1f м", d.relativeAltitude.doubleValue)
            }
        }
        if CMMotionActivityManager.isActivityAvailable() {
            activityManager.startActivityUpdates(to: .main) { [weak self] act in
                guard let a = act else { return }
                var parts: [String] = []
                if a.walking { parts.append("идёт") }
                if a.running { parts.append("бежит") }
                if a.automotive { parts.append("в транспорте") }
                if a.cycling { parts.append("на велосипеде") }
                if a.stationary { parts.append("неподвижен") }
                self?.activity = parts.isEmpty ? "неизвестно" : parts.joined(separator: ", ")
            }
        }
    }

    func stop() {
        running = false
        manager.stopAccelerometerUpdates()
        manager.stopGyroUpdates()
        manager.stopMagnetometerUpdates()
        manager.stopDeviceMotionUpdates()
        pedometer.stopUpdates()
        altimeter.stopRelativeAltitudeUpdates()
        activityManager.stopActivityUpdates()
    }
}
