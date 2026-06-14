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

            LiveSection(title: "Гравитация", api: "CMDeviceMotion.gravity") {
                AxisBar(label: "X", value: motion.gravity.x)
                AxisBar(label: "Y", value: motion.gravity.y)
                AxisBar(label: "Z", value: motion.gravity.z)
            }

            LiveSection(title: "Ускорение пользователя", api: "CMDeviceMotion.userAcceleration") {
                AxisBar(label: "X", value: motion.userAccel.x)
                AxisBar(label: "Y", value: motion.userAccel.y)
                AxisBar(label: "Z", value: motion.userAccel.z)
            }

            LiveSection(title: "Скорость вращения", api: "CMDeviceMotion.rotationRate") {
                AxisBar(label: "X", value: motion.rotationRate.x, range: 6)
                AxisBar(label: "Y", value: motion.rotationRate.y, range: 6)
                AxisBar(label: "Z", value: motion.rotationRate.z, range: 6)
            }

            LiveSection(title: "Положение (attitude)", api: "CMDeviceMotion.attitude") {
                if motion.motionAvailable {
                    InfoRow(label: "Roll", value: String(format: "%+.2f", motion.roll))
                    InfoRow(label: "Pitch", value: String(format: "%+.2f", motion.pitch))
                    InfoRow(label: "Yaw", value: String(format: "%+.2f", motion.yaw))
                    InfoRow(label: "Кватернион", value: motion.quaternion)
                } else { unavailable }
            }

            LiveSection(title: "Барометр / альтиметр", api: "CMAltimeter.startRelativeAltitudeUpdates") {
                if motion.altimeterAvailable {
                    InfoRow(label: "Давление", value: motion.pressure)
                    InfoRow(label: "Отн. высота", value: motion.relativeAltitude)
                } else { unavailable }
            }

            LiveSection(title: "Активность", api: "CMMotionActivityManager.startActivityUpdates") {
                InfoRow(label: "Сейчас", value: motion.activityAvailable ? motion.activity : "недоступно")
            }

            LiveSection(title: "Шагомер", api: "CMPedometer.startUpdates") {
                InfoRow(label: "Шагов сегодня", value: motion.steps.map { "\($0)" } ?? (motion.pedometerAvailable ? "—" : "недоступно"))
                InfoRow(label: "Дистанция", value: motion.distance)
                InfoRow(label: "Этажей вверх", value: motion.floorsUp)
                InfoRow(label: "Темп", value: motion.pace)
                InfoRow(label: "Каденс", value: motion.cadence)
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
