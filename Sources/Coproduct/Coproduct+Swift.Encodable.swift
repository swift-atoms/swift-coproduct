#if hasFeature(VariadicEnum)
#if !hasFeature(Embedded)
extension Coproduct: Swift.Encodable where repeat each Element: Swift.Encodable {

            @inlinable
            public func encode(to encoder: any Encoder) throws(any Swift.Error) {

                var container = encoder.unkeyedContainer()
                switch self {
                case .at(let value):
                    try container.encode(value)
                }
            }
        }
#endif

#endif
