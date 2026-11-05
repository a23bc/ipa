import SwiftUI

private struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize { .zero }
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { value = nextValue() }
}

private struct ChangeObserver<Value: Equatable>: ViewModifier {
    let value: Value
    let initial: Bool
    let onNext: (Value, Value) -> Void
    @State private var last: Value?

    func body(content: Content) -> some View {
        content
            .onAppear {
                guard last == nil else { return }
                last = value
                if initial { onNext(value, value) }
            }
            .onChange(of: value) { next in
                let previous = last ?? next
                last = next
                onNext(previous, next)
            }
    }
}

extension View {
    /// iOS 15 stand-in for `onGeometryChange(for:of:action:)` where only the size is read.
    public func onSizeChange(perform action: @escaping (CGSize) -> Void) -> some View {
        background(GeometryReader { proxy in
            Color.clear.preference(key: SizeKey.self, value: proxy.size)
        })
        .onPreferenceChange(SizeKey.self, perform: action)
    }

    /// iOS 15 stand-ins for the iOS 17 `onChange(of:initial:)` overloads. Named `change` so the
    /// signatures cannot collide with SwiftUI's `onChange(of:perform:)`.
    public func change<Value: Equatable>(
        of value: Value, initial: Bool = false, _ action: @escaping () -> Void
    ) -> some View {
        modifier(ChangeObserver(value: value, initial: initial) { _, _ in action() })
    }

    public func change<Value: Equatable>(
        of value: Value, initial: Bool = false, _ action: @escaping (Value) -> Void
    ) -> some View {
        modifier(ChangeObserver(value: value, initial: initial) { _, next in action(next) })
    }

    public func change<Value: Equatable>(
        of value: Value, initial: Bool = false, _ action: @escaping (Value, Value) -> Void
    ) -> some View {
        modifier(ChangeObserver(value: value, initial: initial, onNext: action))
    }
}

extension Color {
    /// iOS 15 stand-in for `Color.gradient`, which requires iOS 16.
    public var compatibleGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [self, opacity(0.75)]),
            startPoint: .top, endPoint: .bottom)
    }
}

extension Animation {
    /// iOS 15 stand-ins for the iOS 17 `.smooth` and `.bouncy` springs.
    public static let smoothSpring = Animation.spring(response: 0.35, dampingFraction: 0.9)
    public static let bouncySpring = Animation.spring(response: 0.42, dampingFraction: 0.65)
}
