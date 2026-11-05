import Combine
import SwiftUI

/// Stand-in for the iOS 17 `@Bindable` wrapper. Works with `ObservableObject` models, whose
/// `@Published` properties already publish, so bindings created here still refresh the view.
@propertyWrapper
public struct Bindable<Object: ObservableObject> {
    private let object: Object

    public init(_ object: Object) {
        self.object = object
    }

    public var wrappedValue: Object { object }

    public var projectedValue: BindableBindings<Object> { BindableBindings(object: object) }
}

public struct BindableBindings<Object: ObservableObject> {
    fileprivate let object: Object

    public subscript<Value>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Object, Value>
    ) -> Binding<Value> {
        Binding(
            get: { object[keyPath: keyPath] },
            set: { object[keyPath: keyPath] = $0 })
    }
}
