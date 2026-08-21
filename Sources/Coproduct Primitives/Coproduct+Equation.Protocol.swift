#if hasFeature(VariadicEnum)

    extension Coproduct: Equation.`Protocol`
    where repeat each Element: Equation.`Protocol` & ~Copyable {

        @inlinable
        @_disfavoredOverload
        public static func == (lhs: borrowing Coproduct, rhs: borrowing Coproduct) -> Bool {

            switch (lhs, rhs) {
            case (.at(let l), .at(let r)):
                l == r
            }
        }
    }
#endif
