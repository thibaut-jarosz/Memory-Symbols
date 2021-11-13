import Dispatch
import SwiftUI

/// Wait a reasonable time (500ms) for animations to complete, then execute the given code
/// - Parameter execute: the code to execute
///
/// It does not actually detect if there is any animation. It's just a simple helper to prevent writting the same code on multiple locations.
public func waitForAnimation(_ execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(500))) {
        execute()
    }
}

/// Executes a closure without animation and returns the result.
/// - Parameter body: A closure to execute.
/// - Returns: The result of executing the closure.
public func withoutAnimation<Result>(_ body: () throws -> Result) rethrows -> Result {
    var transaction = Transaction(animation: .none)
    transaction.disablesAnimations = true
    return try withTransaction(transaction, body)
}
