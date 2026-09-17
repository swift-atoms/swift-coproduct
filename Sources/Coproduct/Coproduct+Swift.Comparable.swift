#if hasFeature(VariadicEnum)
extension Coproduct: Swift.Comparable
    where repeat each Element: Swift.Comparable & ~Copyable {

        @inlinable
        public static func < (lhs: borrowing Coproduct, rhs: borrowing Coproduct) -> Bool {

            switch (lhs, rhs) {
            case (.at(let l), .at(let r)):
                l < r
            }
        }
    }
#endif
