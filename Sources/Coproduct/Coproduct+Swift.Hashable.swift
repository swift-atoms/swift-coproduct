#if hasFeature(VariadicEnum)
extension Coproduct: Swift.Hashable
    where repeat each Element: Hash::Hash.`Protocol` & ~Copyable {

        @inlinable
        @_disfavoredOverload
        public borrowing func hash(into hasher: inout Hasher) {
            switch self {
            case .at(let value):
                value.hash(into: &hasher)
            }
        }
    }
#endif
