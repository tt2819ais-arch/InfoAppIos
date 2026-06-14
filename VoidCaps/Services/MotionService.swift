import CoreMotion
import Foundation

// Live sensor readouts
final class MotionService: ObservableObject {
    private let manager = CMMotionManager()
    private let pedometer = CMPedometer()

    @Published var accel = SIMDLike()
    @Published var gyro = SIMDLike()
    @Published var mag = SIMDLike()
    @Published var roll = 0.0
    @Published var pitch = 0.0
    @Published var yaw = 0.0
    @Published var steps: Int? = nil
    @Published var running = false

    struct SIMDLike { var x = 0.0; var y = 0.0; var z = 0.0 }

    var accelAvailable: Bool { manager.isAccelerometerAvailable }
    var gyroAvailable: Bool { manager.isGyroAvailable }
    var magAvailable: Bool { manager.isMagnetometerAvailable }
    var motionAvailable: Bool { manager.isDeviceMotionAvailable }
    var pedometerAvailable: Bool { CMPedometer.isStepCountingAvailable() }

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
                guard let a = data?.attitude else { return }
                self?.roll = a.roll; self?.pitch = a.pitch; self?.yaw = a.yaw
            }
        }
        if CMPedometer.isStepCountingAvailable() {
            pedometer.queryPedometerData(from: Calendar.current.startOfDay(for: Date()), to: Date()) { [weak self] data, _ in
                if let n = data?.numberOfSteps.intValue {
                    DispatchQueue.main.async { self?.steps = n }
                }
            }
        }
    }

    func stop() {
        running = false
        manager.stopAccelerometerUpdates()
        manager.stopGyroUpdates()
        manager.stopMagnetometerUpdates()
        manager.stopDeviceMotionUpdates()
    }
}
