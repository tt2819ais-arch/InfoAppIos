import SwiftUI

struct LocationView: View {
    let title: String
    @StateObject private var loc = LocationService()

    var body: some View {
        ScreenScaffold(title: title) {
            LiveSection(title: "Авторизация", api: "CLLocationManager.requestWhenInUseAuthorization") {
                InfoRow(label: "Статус", value: loc.authorization)
            }

            LiveSection(title: "Координаты", api: "CLLocationManager.didUpdateLocations · CLLocation") {
                InfoRow(label: "Широта", value: loc.latitude)
                InfoRow(label: "Долгота", value: loc.longitude)
                InfoRow(label: "Высота", value: loc.altitude)
                InfoRow(label: "Скорость", value: loc.speed)
                InfoRow(label: "Курс", value: loc.course)
                InfoRow(label: "Точность (гор.)", value: loc.hAccuracy)
                InfoRow(label: "Точность (верт.)", value: loc.vAccuracy)
            }

            LiveSection(title: "Компас", api: "CLLocationManager.didUpdateHeading · CLHeading") {
                InfoRow(label: "Направление", value: loc.heading)
            }

            LiveSection(title: "Обратное геокодирование", api: "CLGeocoder.reverseGeocodeLocation") {
                InfoRow(label: "Место", value: loc.place)
            }

            Text("Разреши доступ к геопозиции — значения обновятся вживую.")
                .font(.system(size: 12))
                .foregroundColor(VoidColor.textTertiary)
                .padding(.horizontal, 4)
        }
        .onAppear { loc.start() }
        .onDisappear { loc.stop() }
    }
}
