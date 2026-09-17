#if hasFeature(VariadicEnum)
extension Coproduct: Swift.BitwiseCopyable
    where repeat each Element: Swift.BitwiseCopyable {}
#endif
