#if hasFeature(VariadicEnum)

    public import Coproduct

    extension Coproduct: Swift.Error where repeat each Element: Swift.Error {}

#endif
