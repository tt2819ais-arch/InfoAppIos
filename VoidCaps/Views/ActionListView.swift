import SwiftUI

struct ActionListView: View {
    let title: String
    let capabilities: [Capability]

    var body: some View {
        ScreenScaffold(title: title) {
            ForEach(capabilities) { cap in
                CapabilityRow(capability: cap)
            }
        }
    }
}

struct CapabilityRow: View {
    let capability: Capability
    @State private var revealed = false
    @State private var flash = false
    @State private var resultText: String = ""

    var body: some View {
        Button {
            capability.action()
            Haptics.impact(.soft)
            resultText = capability.dynamicResult?() ?? capability.detail
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                revealed = true
                flash = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 0.4)) { flash = false }
            }
        } label: {
            GlassCard {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(flash ? VoidColor.accent.opacity(0.35) : VoidColor.accentSoft)
                                .frame(width: 40, height: 40)
                            Image(systemName: capability.icon)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(VoidColor.accent)
                        }
                        Text(capability.title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(VoidColor.textPrimary)
                        Spacer()
                        Image(systemName: revealed ? "arrow.clockwise" : "play.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(VoidColor.textTertiary)
                    }

                    if revealed {
                        VStack(alignment: .leading, spacing: 6) {
                            Divider().overlay(VoidColor.stroke).padding(.vertical, 12)
                            Text(capability.api)
                                .voidMono(12)
                                .foregroundColor(VoidColor.accent)
                                .textSelection(.enabled)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(resultText)
                                .font(.system(size: 12))
                                .foregroundColor(VoidColor.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
            }
        }
        .buttonStyle(PressableStyle(scale: 0.98))
    }
}
