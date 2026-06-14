import SwiftUI

// A single triggerable capability (fires an effect, then reveals its API name)
struct Capability: Identifiable {
    let id = UUID()
    let title: String          // Russian label
    let api: String            // exact API call (monospace)
    let detail: String         // one-line description (Russian)
    let icon: String           // SF Symbol
    let action: () -> Void     // triggers the effect
    var dynamicResult: (() -> String)? = nil   // optional live result string
}

enum LiveScreen: String, Identifiable {
    case torch, screen, motion, device, network, permissions
    var id: String { rawValue }
}

enum CategoryKind {
    case actions([Capability])
    case live(LiveScreen)
}

struct CapabilityCategory: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let kind: CategoryKind
}
