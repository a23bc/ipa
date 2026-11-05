import FeatureCore
import IPADesignSystem
import SwiftUI

struct StoreSettingsHost: View {
    @EnvironmentObject private var settings: SettingsModel
    @EnvironmentObject private var session: SessionModel
    @EnvironmentObject private var preferences: StorePreferences
    @EnvironmentObject private var accounts: AccountsModel
    @EnvironmentObject private var downloads: DownloadCenter

    var body: some View {
        ModelHost(
            StoreSettingsModel(
                settings: settings, session: session, preferences: preferences,
                accounts: accounts, downloads: downloads)
        ) {
            StoreRowsSection()
            StorageRowSection()
        }
    }
}

private struct StoreRowsSection: View {
    @EnvironmentObject private var store: StoreSettingsModel

    var body: some View {
        Section {
            SettingsRow(
                "Search", symbol: "magnifyingglass", color: RetroColor.terracotta.color,
                value: store.resultsValue
            ) {
                SettingsPage("Search") { SearchLimitSection() }.environmentObject(store)
            }
            SettingsRow(
                "Device Identity", symbol: "number", color: RetroColor.mustard.color,
                value: store.identityValue
            ) {
                SettingsPage("Device Identity") { IdentitySection() }.environmentObject(store)
            }
            SettingsRow(
                "Store Engine", symbol: "bolt", color: RetroColor.plum.color,
                value: store.engineTitle
            ) {
                SettingsPage("Store Engine") { EngineSection() }.environmentObject(store)
            }
        } header: {
            Text("Store")
        }
        .task { await store.load() }
    }
}

private struct StorageRowSection: View {
    @EnvironmentObject private var store: StoreSettingsModel

    var body: some View {
        Section {
            SettingsRow(
                "Storage", symbol: "externaldrive", color: RetroColor.slate.color,
                value: store.usedSpaceText
            ) {
                SettingsPage("Storage") { StorageSection() }.environmentObject(store)
            }
        } header: {
            Text("Data")
        }
    }
}
