import SwiftUI

extension View {
    @ViewBuilder public func prominentButton() -> some View {
        buttonStyle(.borderedProminent)
    }

    public func primaryButton() -> some View {
        prominentButton()
            .controlSize(.large)
            .font(.headline.weight(.bold))
    }
}
