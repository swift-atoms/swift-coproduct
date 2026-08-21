#if hasFeature(VariadicEnum)

    extension Coproduct where repeat each Element: ~Copyable & ~Escapable {

        @inlinable
        public static func fold<Result: ~Copyable, E: Swift.Error>(
            _ coproduct: consuming Coproduct,
            _ handlers: repeat (consuming each Element) throws(E) -> Result
        ) throws(E) -> Result {
            switch consume coproduct {
            case .at(let value):

                try (each handlers)(consume value)
            }
        }
    }

    extension Coproduct where repeat each Element: ~Copyable & ~Escapable {

        @inlinable
        public consuming func fold<Result: ~Copyable, E: Swift.Error>(
            _ handlers: repeat (consuming each Element) throws(E) -> Result
        ) throws(E) -> Result {
            try Self.fold(self, repeat each handlers)
        }
    }

#endif
