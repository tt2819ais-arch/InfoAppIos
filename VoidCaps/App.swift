import SwiftUI

@main
struct VoidCapsApp: App {
    @State private var launched = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                RootView()
                    .opacity(launched ? 1 : 0)
                if !launched {
                    LaunchView()
                        .transition(.opacity)
                }
            }
            .preferredColorScheme(.dark)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                    withAnimation(.easeInOut(duration: 0.6)) { launched = true }
                }
            }
        }
    }
}
