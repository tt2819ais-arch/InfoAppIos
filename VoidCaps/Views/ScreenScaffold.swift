import SwiftUI

// Shared scaffold: void background + back-aware title header + scroll content
struct ScreenScaffold<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            VoidBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    content
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(VoidColor.textPrimary)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}
