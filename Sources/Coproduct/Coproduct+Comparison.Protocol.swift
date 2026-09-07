#if hasFeature(VariadicEnum)
extension Coproduct: Comparison::Comparison.`Protocol`
    where repeat each Element: Comparison::Comparison.`Protocol` & ~Copyable {

        @inlinable
        @_disfavoredOverload
        public static func < (lhs: borrowing Coproduct, rhs: borrowing Coproduct) -> Bool {

            switch (lhs, rhs) {
            case (.at(let l), .at(let r)):
                l < r
            }
        }
    }
#endif
