import SwiftUI

extension View {
    public func loading(_ isLoading: Bool) -> some View {
        redacted(reason: isLoading ? .placeholder : [])
    }
}

private struct IsLoadingKey: EnvironmentKey {
    static var defaultValue: Bool { false }
}

extension EnvironmentValues {
    public var isLoading: Bool {
        get { self[IsLoadingKey.self] }
        set { self[IsLoadingKey.self] = newValue }
    }
}
