#if hasFeature(VariadicEnum)
extension Coproduct where repeat each Element: ~Copyable {

        @inlinable
        public static func map<each NewElement: ~Copyable, E: Swift.Error>(
            _ coproduct: consuming Coproduct,
            _ transforms: repeat (consuming each Element) throws(E) -> each NewElement
        ) throws(E) -> Coproduct<repeat each NewElement> {
            switch consume coproduct {
            case .at(let value):

                try .at((each transforms)(consume value))
            }
        }
    }
#endif


#if hasFeature(VariadicEnum)
extension Coproduct where repeat each Element: ~Copyable {

        @inlinable
        public consuming func map<each NewElement: ~Copyable, E: Swift.Error>(
            _ transforms: repeat (consuming each Element) throws(E) -> each NewElement
        ) throws(E) -> Coproduct<repeat each NewElement> {
            try Self.map(self, repeat each transforms)
        }
    }
#endif
