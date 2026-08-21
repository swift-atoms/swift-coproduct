#if hasFeature(VariadicEnum)

    @inlinable
    @_lifetime(copy coproduct)
    public func swapped<First: ~Copyable & ~Escapable, Second: ~Copyable & ~Escapable>(
        _ coproduct: consuming Coproduct<First, Second>
    ) -> Coproduct<Second, First> {

        switch consume coproduct {
        case .at(let value):
            .at(consume value)
        }
    }

#endif
