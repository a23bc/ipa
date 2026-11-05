import IPADesignSystem
import IPADomain
import SwiftUI

public struct AccountAvatar: View {
    private let account: Account?
    private let size: CGFloat

    public init(_ account: Account?, size: CGFloat = .badgeL) {
        self.account = account
        self.size = size
    }

    public var body: some View {
        Avatar(account.avatarContent, color: account.avatarColor.color, size: size)
            .accessibilityLabel(account.avatarAccessibilityLabel)
    }
}
