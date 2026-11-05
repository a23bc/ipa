import FeatureCore
import IPADesignSystem
import SwiftUI

struct StorageSection: View {
    @EnvironmentObject private var store: StoreSettingsModel

    var body: some View {
        @Bind var store = store
        Section {
            Button(role: .destructive) {
                store.startErase()
            } label: {
                IconRow(
                    "Erase Everything", detail: "Accounts, downloads and preferences.",
                    symbol: "trash", color: .negative, titleColor: .negative)
            }
            .sheet(isPresented: $store.isErasing, onDismiss: { store.closeErase() }) {
                EraseScreen().environmentObject(store)
            }
        } header: {
            StorageHero()
        } footer: {
            Text(
                "Packages are in the Files app, in IPA › Downloads. Erasing also gives this device a new identity."
            )
        }
    }
}

private struct StorageHero: View {
    @EnvironmentObject private var store: StoreSettingsModel
    @Environment(\.appTint) private var appTint
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: .spaceS) {
            Chip(store.storageChip, color: appTint, shape: Capsule())
            Text(verbatim: store.usedSpaceText)
                .font(.amountHero)
                .foregroundStyle(Color.primary)
                .amountLine()
            Text(verbatim: store.packagesCaption).font(.subheadline).foregroundStyle(.secondary)
        }
        .textCase(nil)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.vertical, .spaceL)
        .accessibilityElement(children: .combine)
        .animation(reduceMotion ? nil : .smoothSpring, value: store.usedBytes)
    }
}
