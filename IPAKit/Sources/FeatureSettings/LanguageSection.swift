import IPADesignSystem
import IPADomain
import SwiftUI

struct LanguageSection: View {
    @EnvironmentObject private var settings: SettingsModel

    var body: some View {
        @Bind var settings = settings
        Section {
            Picker("Language", selection: $settings.language) {
                ForEach(AppLanguage.allCases) { Text($0.nativeName).tag($0) }
            }
            .labelsHidden()
            .pickerStyle(.inline)
        } footer: {
            Text(settings.languageFooter)
        }
    }
}
