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
extension Coproduct: Swift.BitwiseCopyable
    where repeat each Element: Swift.BitwiseCopyable {}
#endif
