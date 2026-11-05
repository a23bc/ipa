import FeatureCore
import IPADesignSystem
import SwiftUI

struct SearchLimitSection: View {
    @EnvironmentObject private var store: StoreSettingsModel

    var body: some View {
        @Bind var store = store
        Section {
            Picker("Results per Search", selection: $store.resultsLimit) {
                ForEach(StorePreferences.limits, id: \.self) { limit in
                    Text(verbatim: store.limitText(limit)).tag(limit)
                }
            }
            .labelsHidden()
            .pickerStyle(.inline)
        } header: {
            Text("Results per Search").sectionTitle()
        } footer: {
            Text(
                "The App Store sends up to 200 results per search. Fewer results load faster on a slow connection."
            )
        }
    }
}
