import FeatureCore
import IPADesignSystem
import SwiftUI

struct IdentitySection: View {
    @EnvironmentObject private var store: StoreSettingsModel

    var body: some View {
        @Bind var store = store
        Section {
            Button(role: .destructive) {
                store.startIdentityChange()
            } label: {
                IconRow(
                    "Generate New Identity", detail: "Every account has to sign in again.",
                    symbol: "arrow.counterclockwise", color: .negative, titleColor: .negative)
            }
            .sheet(isPresented: $store.isConfirmingIdentity) {
                IdentityChangeScreen().environmentObject(store)
            }
        } header: {
            IdentityHero()
        } footer: {
            Text(
                "IPA made this identifier on this device and keeps it in the Keychain. Apple reads it as the network address of the device that signs in."
            )
        }
    }
}

private struct IdentityHero: View {
    @EnvironmentObject private var store: StoreSettingsModel
    @Environment(\.appTint) private var appTint
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: .spaceS) {
            Chip(store.identityChip, color: appTint, shape: .capsule)
            Text(verbatim: store.identityText)
                .font(.amountTitle)
                .monospaced()
                .foregroundStyle(Color.primary)
                .amountLine()
            Text("What Apple sees as this device").font(.subheadline).foregroundStyle(.secondary)
        }
        .textCase(nil)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.vertical, .spaceL)
        .accessibilityElement(children: .combine)
        .animation(reduceMotion ? nil : .smoothSpring, value: store.identityText)
    }
}

private struct IdentityChangeScreen: View {
    @EnvironmentObject private var store: StoreSettingsModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bind var store = store
        GuideSheet(
            index: 0, count: 1,
            primary: GuideAction("Generate New Identity") { store.regenerateIdentity() },
            secondary: GuideAction("Cancel") { dismiss() }
        ) {
            GuidePage(
                title: "New Device Identity?",
                message:
                    "Apple will see a new device. Every account signs out and has to sign in again."
            ) {
                IPAAnimationView(.identity)
            } content: {
                GuideValueList(
                    store.identityValues.map {
                        GuideValue($0.label, value: $0.value, color: $0.color)
                    }
                )
            }
        }
        .accentColor(Color.negative)
        .errorAlert($store.error)
    }
}
