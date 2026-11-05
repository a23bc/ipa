import Combine
import SwiftUI

/// iOS 15 stand-in for the iOS 17 `@Bindable` wrapper, named `Bind` because a same-named
/// `Bindable` would be ambiguous with SwiftUI's. Works with `ObservableObject` models, whose
/// `@Published` properties already publish, so bindings created here still refresh the view.
@propertyWrapper
public struct Bind<Object: ObservableObject> {
    private let object: Object

    public init(wrappedValue object: Object) {
        self.object = object
    }

    public var wrappedValue: Object { object }

    public var projectedValue: BindBindings<Object> { BindBindings(object: object) }
}

@dynamicMemberLookup
public struct BindBindings<Object: ObservableObject> {
    fileprivate let object: Object

    public subscript<Value>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Object, Value>
    ) -> Binding<Value> {
        Binding(
            get: { object[keyPath: keyPath] },
            set: { object[keyPath: keyPath] = $0 })
    }
}
