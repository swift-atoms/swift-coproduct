#if hasFeature(VariadicEnum)
extension Coproduct where repeat each Element: ~Copyable {

        @inlinable
        public static func flatMap<each NewElement: ~Copyable, E: Swift.Error>(
            _ coproduct: consuming Coproduct,
            _ transforms:
                repeat (consuming each Element) throws(E) -> Coproduct<repeat each NewElement>
        ) throws(E) -> Coproduct<repeat each NewElement> {
            switch consume coproduct {
            case .at(let value):

                try (each transforms)(consume value)
            }
        }
    }
#endif


#if hasFeature(VariadicEnum)
extension Coproduct where repeat each Element == FirstElement, FirstElement: ~Copyable {

        @inlinable
        public static func flatMap<each NewElement: ~Copyable, E: Swift.Error>(
            _ coproduct: consuming Coproduct,
            _ transform:
                (consuming FirstElement) throws(E) -> Coproduct<repeat each NewElement>
        ) throws(E) -> Coproduct<repeat each NewElement> {
            switch consume coproduct {
            case .at(let value):
                try transform(consume value)
            }
        }
    }
#endif


#if hasFeature(VariadicEnum)
extension Coproduct where repeat each Element: ~Copyable {

        @inlinable
        public consuming func flatMap<each NewElement: ~Copyable, E: Swift.Error>(
            _ transforms:
                repeat (consuming each Element) throws(E) -> Coproduct<repeat each NewElement>
        ) throws(E) -> Coproduct<repeat each NewElement> {
            try Self.flatMap(self, repeat each transforms)
        }
    }
#endif
