// Coproduct+Equation.Protocol.swift
// Conformance of Coproduct to Equation.Protocol — unconditional.
//

// Gated `#if hasFeature(VariadicEnum)`. See `Coproduct.swift` for the
// top-level gate.

#if hasFeature(VariadicEnum)

    // `Equation.Protocol` aliases `Swift.Equatable`, which requires escapable arms.
    extension Coproduct: Equation.`Protocol`
    where repeat each Element: Equation.`Protocol` & ~Copyable {
        /// Returns whether two `Coproduct` values are equal.
        ///
        /// Two coproducts are equal when their active arms match in position
        /// *and* their payloads compare equal under `Equation.Protocol`. A
        /// `.at(L)` at position `i` and a `.at(R)` at position `j` with `i ≠ j`
        /// are never equal regardless of payload.
        ///
        /// - Note: Uses `@_disfavoredOverload` so synthesized equality is preferred
        ///   for Copyable arms; the borrowing path is selected for `~Copyable` arms.
        @inlinable
        @_disfavoredOverload
        public static func == (lhs: borrowing Coproduct, rhs: borrowing Coproduct) -> Bool {
            // Placeholder body. Equality holds when `lhs` and `rhs` inhabit
            // the same pack position AND their payloads compare equal under
            // `Equation.Protocol`. The pack-position comparison follows the
            // shipped pack-eliminator syntax.
            switch (lhs, rhs) {
            case (.at(let l), .at(let r)):
                l == r
            }
        }
    }
#endif  // hasFeature(VariadicEnum)
