import SwiftUI

/// iOS 15 stand-in for `ContentUnavailableView`, keeping the same trailing-closure call shape.
public struct UnavailableState<Label: View, Description: View, Actions: View>: View {
    private let label: Label
    private let description: Description
    private let actions: Actions

    public init(
        @ViewBuilder label: () -> Label,
        @ViewBuilder description: () -> Description = { EmptyView() },
        @ViewBuilder actions: () -> Actions = { EmptyView() }
    ) {
        self.label = label()
        self.description = description()
        self.actions = actions()
    }

    public var body: some View {
        VStack(spacing: .spaceM) {
            label
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.secondary)
            description
                .font(.footnote)
                .foregroundStyle(Color.secondary)
                .multilineTextAlignment(.center)
            actions
        }
        .padding(.spaceL)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension UnavailableState where Label == Image, Description == Text, Actions == EmptyView {
    init(_ title: String, systemImage: String) {
        self.init(label: { Image(systemName: systemImage) }, description: { Text(title) })
    }

    public static func search(text: String) -> some View {
        UnavailableState("No Results for “\(text)”", systemImage: "magnifyingglass")
    }
}
