import SwiftUI

private struct AppTintKey: EnvironmentKey {
    static var defaultValue: Color { .accentColor }
}

extension EnvironmentValues {
    public var appTint: Color {
        get { self[AppTintKey.self] }
        set { self[AppTintKey.self] = newValue }
    }
}

extension View {
    public func appTint(_ color: Color) -> some View {
        tint(color).environment(\.appTint, color)
    }
}
