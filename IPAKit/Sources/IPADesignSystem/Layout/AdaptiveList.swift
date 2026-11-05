import SwiftUI

/// iOS 15 has no way to enumerate a view's sections, which is what the multi-column grouped
/// layout needed; a single grouped `List` is what those columns collapsed to on a phone anyway.
public struct AdaptiveList<SelectionValue: Hashable, Content: View>: View {
    private let selection: Binding<Set<SelectionValue>>?
    private let content: Content

    public init(
        selection: Binding<Set<SelectionValue>>?, @ViewBuilder content: () -> Content
    ) {
        self.selection = selection
        self.content = content()
    }

    public var body: some View {
        List(selection: selection) { content }
    }
}

extension AdaptiveList where SelectionValue == Never {
    public init(@ViewBuilder content: () -> Content) {
        self.init(selection: nil, content: content)
    }
}
