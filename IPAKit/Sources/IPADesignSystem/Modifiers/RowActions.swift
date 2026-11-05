import SwiftUI

extension View {
    public func deleteAction(_ action: @escaping () -> Void) -> some View {
        swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("Delete", systemImage: "trash.fill", role: .destructive, action: action)
                .accentColor(.negative)
        }
    }

    public func editAction(_ action: @escaping () -> Void) -> some View {
        swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Edit", systemImage: "square.and.pencil", action: action)
                .accentColor(.info)
        }
    }
}
