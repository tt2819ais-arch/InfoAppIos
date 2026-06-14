import SwiftUI

struct MotionView: View {
    let title: String
    @StateObject private var motion = MotionService()

    var body: some View {
        ScreenScaffold(title: title) {
            LiveSection(title: "Акселерометр", api: "CMMotionManager.accelerometerData") {
                if motion.accelAvailable {
                    AxisBar(label: "X", value: motion.accel.x)
                    AxisBar(label: "Y", value: motion.accel.y)
                    AxisBar(label: "Z", value: motion.accel.z)
                } else { unavailable }
            }

            LiveSection(title: "Гироскоп", api: "CMMotionManager.gyroData") {
                if motion.gyroAvailable {
                    AxisBar(label: "X", value: motion.gyro.x, range: 6)
                    AxisBar(label: "Y", value: motion.gyro.y, range: 6)
                    AxisBar(label: "Z", value: motion.gyro.z, range: 6)
                } else { unavailable }
            }

            LiveSection(title: "Магнитометр", api: "CMMotionManager.magnetometerData") {
                if motion.magAvailable {
                    AxisBar(label: "X", value: motion.mag.x, range: 80)
                    AxisBar(label: "Y", value: motion.mag.y, range: 80)
                    AxisBar(label: "Z", value: motion.mag.z, range: 80)
                } else { unavailable }
            }

            LiveSection(title: "Положение (attitude)", api: "CMDeviceMotion.attitude") {
                if motion.motionAvailable {
                    InfoRow(label: "Roll", value: String(format: "%+.2f", motion.roll))
                    InfoRow(label: "Pitch", value: String(format: "%+.2f", motion.pitch))
                    InfoRow(label: "Yaw", value: String(format: "%+.2f", motion.yaw))
                } else { unavailable }
            }

            LiveSection(title: "Шагомер", api: "CMPedometer.queryPedometerData") {
                InfoRow(label: "Шагов сегодня", value: motion.steps.map { "\($0)" } ?? (motion.pedometerAvailable ? "—" : "недоступно"))
            }
        }
        .onAppear { motion.start() }
        .onDisappear { motion.stop() }
    }

    private var unavailable: some View {
        Text("Датчик недоступен")
            .font(.system(size: 13))
            .foregroundColor(VoidColor.textSecondary)
    }
}
