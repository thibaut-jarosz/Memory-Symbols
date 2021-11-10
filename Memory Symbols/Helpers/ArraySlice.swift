/// Duplicate content of an array
/// - Returns: self + self
///
/// It's just a simple helper that present creating an intermediate variable
extension ArraySlice {
    @inlinable func duplicated() -> Self {
        self + self
    }
}
