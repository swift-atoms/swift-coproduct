#if hasFeature(VariadicEnum)

    public import Coproduct

    extension Coproduct: CustomStringConvertible
    where repeat each Element: CustomStringConvertible {

        @inlinable
        public var description: String {
            switch self {
            case .at(let value):

                "at(\(value))"
            }
        }
    }

#endif
