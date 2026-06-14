import SwiftUI

struct LaunchView: View {
    @State private var ringScale: CGFloat = 0.6
    @State private var ringOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var titleBlur: CGFloat = 12

    var body: some View {
        ZStack {
            VoidBackground()
            VStack(spacing: 22) {
                ZStack {
                    Circle()
                        .stroke(VoidColor.accent.opacity(0.35), lineWidth: 1.5)
                        .frame(width: 96, height: 96)
                        .scaleEffect(ringScale)
                        .opacity(ringOpacity)
                    Circle()
                        .fill(VoidColor.accent.opacity(0.12))
                        .frame(width: 16, height: 16)
                        .opacity(ringOpacity)
                }
                Text("void")
                    .font(.system(size: 40, weight: .thin, design: .rounded))
                    .tracking(8)
                    .foregroundColor(VoidColor.textPrimary)
                    .opacity(titleOpacity)
                    .blur(radius: titleBlur)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                ringScale = 1.0
                ringOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.9).delay(0.25)) {
                titleOpacity = 1.0
                titleBlur = 0
            }
        }
    }
}
