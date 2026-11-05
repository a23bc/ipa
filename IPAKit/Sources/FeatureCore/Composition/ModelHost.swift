import SwiftUI

public struct ModelHost<Model: ObservableObject, Content: View>: View {
    @State private var model: Model
    private let content: Content

    public init(_ model: @autoclosure () -> Model, @ViewBuilder content: () -> Content) {
        _model = State(initialValue: model())
        self.content = content()
    }

    public var body: some View {
        content.environmentObject(model)
    }
}
