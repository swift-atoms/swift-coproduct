#if hasFeature(VariadicEnum)
extension Coproduct: Swift.Equatable
    where repeat each Element: Swift.Equatable & ~Copyable {

        @inlinable
        public static func == (lhs: borrowing Coproduct, rhs: borrowing Coproduct) -> Bool {

            switch (lhs, rhs) {
            case (.at(let l), .at(let r)):
                l == r
            }
        }
    }
#endif
