#if hasFeature(VariadicEnum)
    @frozen
    public enum Coproduct<each Element: ~Copyable & ~Escapable>: ~Copyable, ~Escapable {

        case at(each Element)
    }
#endif

#if hasFeature(VariadicEnum)
    extension Coproduct: Swift::Copyable
    where repeat each Element: Swift::Copyable & ~Escapable {}
#endif

#if hasFeature(VariadicEnum)
    extension Coproduct: Swift::Escapable
    where repeat each Element: Swift::Escapable & ~Copyable {}
#endif

#if hasFeature(VariadicEnum)
    extension Coproduct: Swift::Sendable
    where repeat each Element: Swift::Sendable & ~Copyable & ~Escapable {}
#endif

#if hasFeature(VariadicEnum)
    #if !hasFeature(Embedded)
        extension Coproduct: Swift::Codable where repeat each Element: Swift::Codable {}
    #endif

#endif

#if hasFeature(VariadicEnum)
    extension Coproduct where repeat each Element: ~Copyable & ~Escapable {

        @inlinable
        public static func fold<Result: ~Copyable, E: Swift::Error>(
            _ coproduct: consuming Coproduct,
            _ handlers: repeat (consuming each Element) throws(E) -> Result
        ) throws(E) -> Result {
            switch consume coproduct {
            case .at(let value):

                try (each handlers)(consume value)
            }
        }
    }
#endif

#if hasFeature(VariadicEnum)
    extension Coproduct where repeat each Element: ~Copyable & ~Escapable {

        @inlinable
        public consuming func fold<Result: ~Copyable, E: Swift::Error>(
            _ handlers: repeat (consuming each Element) throws(E) -> Result
        ) throws(E) -> Result {
            try Self.fold(self, repeat each handlers)
        }
    }
#endif

#if hasFeature(VariadicEnum)
    extension Coproduct where repeat each Element: ~Copyable {

        @inlinable
        public static func map<each NewElement: ~Copyable, E: Swift::Error>(
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
        public consuming func map<each NewElement: ~Copyable, E: Swift::Error>(
            _ transforms: repeat (consuming each Element) throws(E) -> each NewElement
        ) throws(E) -> Coproduct<repeat each NewElement> {
            try Self.map(self, repeat each transforms)
        }
    }
#endif

#if hasFeature(VariadicEnum)
    extension Coproduct: Swift::BitwiseCopyable
    where repeat each Element: Swift::BitwiseCopyable {}
#endif

#if hasFeature(VariadicEnum)
    extension Coproduct: Swift::Comparable
    where repeat each Element: Swift::Comparable & ~Copyable {

        @inlinable
        public static func < (lhs: borrowing Coproduct, rhs: borrowing Coproduct) -> Bool {

            switch (lhs, rhs) {
            case (.at(let l), .at(let r)):
                l < r
            }
        }
    }
#endif

#if hasFeature(VariadicEnum)
    extension Coproduct: Swift::CustomStringConvertible
    where repeat each Element: Swift::CustomStringConvertible {

        @inlinable
        public var description: String {
            switch self {
            case .at(let value):

                "at(\(value))"
            }
        }
    }
#endif

#if hasFeature(VariadicEnum)
    #if !hasFeature(Embedded)
        extension Coproduct: Swift::Decodable where repeat each Element: Swift::Decodable {

            @inlinable
            public init(from decoder: any Decoder) throws(any Swift::Error) {
                var container = try decoder.unkeyedContainer()
                let position = try container.decode(UInt.self)

                _ = position
                fatalError("Pack-position decoding pending the shipped pack-eliminator syntax")
            }
        }
    #endif

#endif

#if hasFeature(VariadicEnum)
    #if !hasFeature(Embedded)
        extension Coproduct: Swift::Encodable where repeat each Element: Swift::Encodable {

            @inlinable
            public func encode(to encoder: any Encoder) throws(any Swift::Error) {

                var container = encoder.unkeyedContainer()
                switch self {
                case .at(let value):
                    try container.encode(value)
                }
            }
        }
    #endif

#endif

#if hasFeature(VariadicEnum)
    extension Coproduct: Swift::Equatable
    where repeat each Element: Swift::Equatable & ~Copyable {

        @inlinable
        public static func == (lhs: borrowing Coproduct, rhs: borrowing Coproduct) -> Bool {

            switch (lhs, rhs) {
            case (.at(let l), .at(let r)):
                l == r
            }
        }
    }
#endif

#if hasFeature(VariadicEnum)
    extension Coproduct: Swift::Error where repeat each Element: Swift::Error {}
#endif

#if hasFeature(VariadicEnum)
    extension Coproduct: Swift::Hashable
    where repeat each Element: Swift::Hashable & ~Copyable {

        @inlinable
        public borrowing func hash(into hasher: inout Hasher) {
            switch self {
            case .at(let value):
                value.hash(into: &hasher)
            }
        }
    }
#endif
