import FeatureAccounts
import FeatureCore
import FeatureSearch
import SwiftUI

struct RouteScreen: View {
    @EnvironmentObject private var session: SessionModel
    @EnvironmentObject private var preferences: StorePreferences
    @EnvironmentObject private var accounts: AccountsModel
    @EnvironmentObject private var downloads: DownloadCenter
    let route: Route

    @ViewBuilder var body: some View {
        switch route {
        case .app(let id):
            ModelHost(
                AppModel(
                    id: id, session: session, preferences: preferences, accounts: accounts,
                    downloads: downloads)
            ) {
                AppScreen()
            }
        case .storefronts: StorefrontScreen()
        case .signIn:
            ModelHost(SignInModel(session: session, accounts: accounts)) { SignInScreen() }
        }
    }
}
