#if hasFeature(VariadicEnum)
extension Coproduct: Swift.Error where repeat each Element: Swift.Error {}
#endif
