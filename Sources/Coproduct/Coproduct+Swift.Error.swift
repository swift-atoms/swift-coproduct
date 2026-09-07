#if hasFeature(VariadicEnum)
@_exported public import Comparison
#endif

#if hasFeature(VariadicEnum)
@_exported public import Equation
#endif

#if hasFeature(VariadicEnum)
@_exported public import Hash
#endif


#if hasFeature(VariadicEnum)
extension Coproduct: Swift.Error where repeat each Element: Swift.Error {}
#endif
