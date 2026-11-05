import IPADesignSystem
import IPADomain
import SwiftUI

public struct AccountMenu: View {
    @EnvironmentObject private var accounts: AccountsModel
    @Environment(\.open) private var open
    @Environment(\.navigationSection) private var section

    public init() {}

    public var body: some View {
        @Bind var accounts = accounts
        Menu {
            if !accounts.accounts.isEmpty {
                Picker(selection: $accounts.selection) {
                    ForEach(accounts.accounts) { account in
                        Label {
                            Text(verbatim: account.displayName)
                        } icon: {
                            AccountAvatar(account, size: .badgeS)
                        }
                        .tag(Optional(account.email))
                    }
                } label: {
                    EmptyView()
                }
                Divider()
            }
            Button("Add Account", systemImage: "person.badge.plus") {
                open(.signIn, in: section)
            }
        } label: {
            AccountAvatar(accounts.active, size: .badgeM)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Account")
    }
}
