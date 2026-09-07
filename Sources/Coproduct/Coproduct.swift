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
@frozen
    public enum Coproduct<each Element: ~Copyable & ~Escapable>: ~Copyable, ~Escapable {

        case at(each Element)
    }
#endif


#if hasFeature(VariadicEnum)
extension Coproduct: Swift.Copyable
    where repeat each Element: Swift.Copyable & ~Escapable {}
#endif


#if hasFeature(VariadicEnum)
extension Coproduct: Swift.Escapable
    where repeat each Element: Swift.Escapable & ~Copyable {}
#endif


#if hasFeature(VariadicEnum)
extension Coproduct: Swift.Sendable
    where repeat each Element: Swift.Sendable & ~Copyable & ~Escapable {}
#endif


#if hasFeature(VariadicEnum)
#if !hasFeature(Embedded)
extension Coproduct: Swift.Codable where repeat each Element: Swift.Codable {}
#endif

#endif
