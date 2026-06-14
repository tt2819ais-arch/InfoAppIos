import SwiftUI

// Monospace API tag
struct ApiTag: View {
    let text: String
    var body: some View {
        Text(text)
            .voidMono(11)
            .foregroundColor(VoidColor.accent)
            .padding(.vertical, 5).padding(.horizontal, 9)
            .background(RoundedRectangle(cornerRadius: 8).fill(VoidColor.accentSoft))
            .fixedSize(horizontal: false, vertical: true)
    }
}

// A labeled value row
struct InfoRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(VoidColor.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(VoidColor.textPrimary)
                .multilineTextAlignment(.trailing)
        }
    }
}

// Section wrapper with title + api tag
struct LiveSection<Content: View>: View {
    let title: String
    var api: String? = nil
    @ViewBuilder var content: Content
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(VoidColor.textPrimary)
                    Spacer()
                }
                content
                if let api = api {
                    ApiTag(text: api)
                }
            }
        }
    }
}

// Live bar for a sensor axis
struct AxisBar: View {
    let label: String
    let value: Double
    var range: Double = 2.0
    var body: some View {
        HStack(spacing: 10) {
            Text(label)
                .voidMono(12)
                .foregroundColor(VoidColor.textSecondary)
                .frame(width: 18, alignment: .leading)
            GeometryReader { geo in
                let mid = geo.size.width / 2
                let clamped = max(-range, min(value, range))
                let w = abs(clamped) / range * mid
                ZStack(alignment: .leading) {
                    Capsule().fill(VoidColor.stroke).frame(height: 4)
                    Capsule()
                        .fill(VoidColor.accent)
                        .frame(width: max(2, w), height: 4)
                        .offset(x: clamped >= 0 ? mid : mid - w)
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .frame(height: 14)
            Text(String(format: "%+.2f", value))
                .voidMono(11)
                .foregroundColor(VoidColor.textPrimary)
                .frame(width: 56, alignment: .trailing)
        }
    }
}
