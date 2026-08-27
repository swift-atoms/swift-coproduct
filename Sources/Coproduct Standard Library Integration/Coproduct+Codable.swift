#if hasFeature(VariadicEnum)
    #if !hasFeature(Embedded)

        public import Coproduct

        extension Coproduct: Codable where repeat each Element: Codable {}

    #endif
#endif
