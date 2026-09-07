#if hasFeature(VariadicEnum)
extension Coproduct: Hash::Hash.`Protocol`
    where repeat each Element: Hash::Hash.`Protocol` & ~Copyable {}
#endif
