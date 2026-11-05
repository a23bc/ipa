import IPADesignSystem
import SwiftUI

extension View {
    public func ipaSettings(_ settings: SettingsModel) -> some View {
        modifier(AppearanceModifier()).environmentObject(settings)
    }
}

private struct AppearanceModifier: ViewModifier {
    @EnvironmentObject private var settings: SettingsModel

    func body(content: Content) -> some View {
        content
            .appTint(Color(hex: settings.tint))
            .environment(\.locale, settings.locale)
            .change(of: settings.appearance, initial: true) { settings.appearance.apply() }
            .change(of: settings.tint, initial: true) {
                Appearance.applyTint(Color(hex: settings.tint))
            }
    }
}
