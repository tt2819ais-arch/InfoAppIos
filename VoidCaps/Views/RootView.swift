import SwiftUI

struct RootView: View {
    private let categories = Catalog.categories

    var body: some View {
        NavigationStack {
            ZStack {
                VoidBackground()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        header
                        ForEach(categories) { category in
                            NavigationLink {
                                destination(for: category)
                            } label: {
                                CategoryCard(category: category)
                            }
                            .buttonStyle(PressableStyle())
                            .simultaneousGesture(TapGesture().onEnded { Haptics.selection() })
                        }
                        footer
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
        .tint(VoidColor.accent)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("void")
                .font(.system(size: 34, weight: .thin, design: .rounded))
                .tracking(6)
                .foregroundColor(VoidColor.textPrimary)
            Text("каталог возможностей iPhone")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(VoidColor.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 24)
        .padding(.bottom, 4)
    }

    private var footer: some View {
        VStack(spacing: 4) {
            Text("Нажми на категорию, вызови функцию —")
            Text("приложение покажет её системное имя")
        }
        .font(.system(size: 12))
        .foregroundColor(VoidColor.textTertiary)
        .frame(maxWidth: .infinity)
        .padding(.top, 12)
    }

    @ViewBuilder
    private func destination(for category: CapabilityCategory) -> some View {
        switch category.kind {
        case .actions(let caps):
            ActionListView(title: category.title, capabilities: caps)
        case .live(let screen):
            liveView(screen, title: category.title)
        }
    }

    @ViewBuilder
    private func liveView(_ screen: LiveScreen, title: String) -> some View {
        switch screen {
        case .torch: TorchView(title: title)
        case .screen: ScreenView(title: title)
        case .motion: MotionView(title: title)
        case .device: DeviceView(title: title)
        case .network: NetworkView(title: title)
        case .location: LocationView(title: title)
        case .connectivity: ConnectivityView(title: title)
        case .security: SecurityView(title: title)
        case .media: MediaView(title: title)
        case .permissions: PermissionsView(title: title)
        }
    }
}

struct CategoryCard: View {
    let category: CapabilityCategory
    var body: some View {
        GlassCard {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(VoidColor.accentSoft)
                        .frame(width: 48, height: 48)
                    Image(systemName: category.icon)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(VoidColor.accent)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(category.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(VoidColor.textPrimary)
                    Text(category.subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(VoidColor.textSecondary)
                }
                Spacer()
                if let n = category.itemCount {
                    Text("\(n)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(VoidColor.accent)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Capsule().fill(VoidColor.accentSoft))
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(VoidColor.textTertiary)
            }
        }
    }
}
