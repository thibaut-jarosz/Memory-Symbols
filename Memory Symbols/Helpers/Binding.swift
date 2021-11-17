import SwiftUI

extension Binding {
    /// Transform an optional binding to non-optional, by using `defaultValue` as value is `wrappedValue` is `nil`.
    /// - Parameter defaultValue: value returned by getter if `wrappedValue` is `nil`
    /// - Returns: a non-optional binding
    func toNonOptional<T>(defaultValue: @escaping () -> T) -> Binding<T> where Value == T? {
        Binding<T>(
            get: { wrappedValue ?? defaultValue() },
            set: { wrappedValue = $0 }
        )
    }
}
