import SwiftUI

extension View {
    public func surface(
        tint: Color? = nil, in shape: some InsettableShape, interactive: Bool = false
    ) -> some View {
        modifier(FlatSurface(tint: tint, shape: shape))
    }

    public func clearSurface(in shape: some InsettableShape) -> some View {
        modifier(ClearSurface(shape: shape))
    }

    public func contentSurface(tint: Color? = nil, in shape: some Shape) -> some View {
        background(tint ?? .subtleFill, in: shape)
    }
}

// iOS 26 glass has no iOS 15 counterpart, so surfaces become translucent fills.
private struct ClearSurface<S: InsettableShape>: ViewModifier {
    let shape: S

    func body(content: Content) -> some View {
        content.background(.ultraThinMaterial, in: shape)
    }
}

private struct FlatSurface<S: InsettableShape>: ViewModifier {
    let tint: Color?
    let shape: S

    func body(content: Content) -> some View {
        content.background(tint ?? Color.primary.opacity(0.06), in: shape)
    }
}
