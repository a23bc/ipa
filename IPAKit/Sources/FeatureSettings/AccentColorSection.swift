import FeatureCore
import IPADesignSystem
import SwiftUI

struct AccentColorSection: View {
    @EnvironmentObject private var settings: SettingsModel
    @Environment(\.appTint) private var appTint

    var body: some View {
        @Bindable var settings = settings
        Section {
            RetroColorPicker(hex: $settings.tint)
        } header: {
            HStack(alignment: .firstTextBaseline) {
                Text("Accent Color").sectionTitle()
                Spacer()
                Text(settings.tintName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(appTint)
                    .lineLimit(1)
            }
            .textCase(nil)
        } footer: {
            Text("The accent color appears on buttons, tabs, selections and charts.")
        }
    }
}
