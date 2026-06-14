import SwiftUI

// MARK: - Void palette
enum VoidColor {
    static let bg = Color(red: 0.039, green: 0.039, blue: 0.043)       // #0A0A0B near-black
    static let bgRaised = Color(red: 0.071, green: 0.071, blue: 0.078) // slightly lifted
    static let card = Color.white.opacity(0.045)
    static let stroke = Color.white.opacity(0.08)
    static let textPrimary = Color.white.opacity(0.94)
    static let textSecondary = Color.white.opacity(0.5)
    static let textTertiary = Color.white.opacity(0.32)
    static let accent = Color(red: 0.55, green: 0.53, blue: 0.96)      // restrained lavender
    static let accentSoft = Color(red: 0.55, green: 0.53, blue: 0.96).opacity(0.16)
}

// MARK: - Void background (Canvas + TimelineView, no .blur -> buttery, GPU-light)
struct VoidBackground: View {
    var body: some View {
        ZStack {
            VoidColor.bg.ignoresSafeArea()
            TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
                Canvas { context, size in
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    drawOrb(context: context, size: size,
                            cx: 0.28 + 0.06 * sin(t * 0.07),
                            cy: 0.22 + 0.05 * cos(t * 0.05),
                            radius: 0.62,
                            color: VoidColor.accent.opacity(0.16))
                    drawOrb(context: context, size: size,
                            cx: 0.82 + 0.05 * cos(t * 0.06),
                            cy: 0.78 + 0.05 * sin(t * 0.045),
                            radius: 0.7,
                            color: Color(red: 0.18, green: 0.22, blue: 0.42).opacity(0.22))
                    drawOrb(context: context, size: size,
                            cx: 0.7 + 0.04 * sin(t * 0.04),
                            cy: 0.1 + 0.03 * cos(t * 0.08),
                            radius: 0.4,
                            color: Color(red: 0.12, green: 0.12, blue: 0.18).opacity(0.5))
                }
                .ignoresSafeArea()
            }
            // faint vignette to deepen the void
            RadialGradient(colors: [.clear, Color.black.opacity(0.55)],
                           center: .center, startRadius: 120, endRadius: 520)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
    }

    private func drawOrb(context: GraphicsContext, size: CGSize,
                         cx: Double, cy: Double, radius: Double, color: Color) {
        let center = CGPoint(x: cx * size.width, y: cy * size.height)
        let r = radius * max(size.width, size.height)
        let rect = CGRect(x: center.x - r, y: center.y - r, width: r * 2, height: r * 2)
        let gradient = Gradient(colors: [color, color.opacity(0)])
        context.fill(
            Path(ellipseIn: rect),
            with: .radialGradient(gradient, center: center, startRadius: 0, endRadius: r)
        )
    }
}

// MARK: - Glass card
struct GlassCard<Content: View>: View {
    var padding: CGFloat = 16
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(VoidColor.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(VoidColor.stroke, lineWidth: 1)
            )
    }
}

// MARK: - Pressable style
struct PressableStyle: ButtonStyle {
    var scale: CGFloat = 0.97
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension View {
    func voidMono(_ size: CGFloat = 13) -> some View {
        self.font(.system(size: size, weight: .medium, design: .monospaced))
    }
}
