#if hasFeature(VariadicEnum)
#if !hasFeature(Embedded)
extension Coproduct: Swift.Decodable where repeat each Element: Swift.Decodable {

            @inlinable
            public init(from decoder: any Decoder) throws(any Swift.Error) {
                var container = try decoder.unkeyedContainer()
                let position = try container.decode(UInt.self)

                _ = position
                fatalError("Pack-position decoding pending the shipped pack-eliminator syntax")
            }
        }
#endif

#endif
