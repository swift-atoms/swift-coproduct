#if hasFeature(VariadicEnum)
extension Coproduct: Swift.CustomStringConvertible
    where repeat each Element: Swift.CustomStringConvertible {

        @inlinable
        public var description: String {
            switch self {
            case .at(let value):

                "at(\(value))"
            }
        }
    }
#endif
