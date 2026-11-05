import SwiftUI

private struct OpenKey: EnvironmentKey {
    static var defaultValue: IPADestination { .init { _, _ in } }
}

private struct CloseKey: EnvironmentKey {
    static var defaultValue: CloseAction { .init {} }
}

private struct NavigationSectionKey: EnvironmentKey {
    static var defaultValue: AppSection { .search }
}

extension EnvironmentValues {
    public var open: IPADestination {
        get { self[OpenKey.self] }
        set { self[OpenKey.self] = newValue }
    }

    public var close: CloseAction {
        get { self[CloseKey.self] }
        set { self[CloseKey.self] = newValue }
    }

    public var navigationSection: AppSection {
        get { self[NavigationSectionKey.self] }
        set { self[NavigationSectionKey.self] = newValue }
    }
}
