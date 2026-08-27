#if hasFeature(VariadicEnum)

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

#endif
