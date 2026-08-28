#if hasFeature(VariadicEnum)

    @_exported public import Comparison_Protocol
    @_exported public import Equation_Protocol
    @_exported public import Hash_Protocol

    @frozen
    public enum Coproduct<each Element: ~Copyable & ~Escapable>: ~Copyable, ~Escapable {

        case at(each Element)
    }

    extension Coproduct: Copyable
    where repeat each Element: Copyable & ~Escapable {}

    extension Coproduct: Escapable
    where repeat each Element: Escapable & ~Copyable {}

    extension Coproduct: Sendable
    where repeat each Element: Sendable & ~Copyable & ~Escapable {}

    extension Coproduct: BitwiseCopyable
    where repeat each Element: BitwiseCopyable {}

    #if !hasFeature(Embedded)
        extension Coproduct: Codable where repeat each Element: Codable {}
    #endif

    extension Coproduct: Swift.Error where repeat each Element: Swift.Error {}

#endif
