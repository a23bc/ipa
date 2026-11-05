import FeatureAccounts
import FeatureCore
import FeatureLibrary
import FeatureSearch
import FeatureSettings
import SwiftUI

struct SectionScreen: View {
    @EnvironmentObject private var session: SessionModel
    @EnvironmentObject private var preferences: StorePreferences
    @EnvironmentObject private var accounts: AccountsModel
    @EnvironmentObject private var downloads: DownloadCenter
    let section: AppSection

    @ViewBuilder var body: some View {
        switch section {
        case .search:
            ModelHost(SearchModel(session: session, preferences: preferences, accounts: accounts)) {
                SearchScreen()
            }
        case .downloads:
            ModelHost(LibraryModel(downloads: downloads, accounts: accounts)) { LibraryScreen() }
        case .accounts: AccountsScreen()
        case .settings: SettingsScreen()
        }
    }
}
