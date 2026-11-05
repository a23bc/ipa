import SwiftUI

extension View {
    public func readableWidth(_ width: CGFloat = 560) -> some View {
        modifier(ReadableWidth(width: width))
    }
}

private struct ReadableWidth: ViewModifier {
    let width: CGFloat
    @State private var margin: CGFloat?

    func body(content: Content) -> some View {
        content
            .onSizeChange {
                let excess = ($0.width - width) / 2
                margin = excess > 20 ? excess : nil
            }
    }
}
