#if hasFeature(VariadicEnum)

    @inlinable
    @_lifetime(copy coproduct)
    public func value<each Other, Inhabited: ~Copyable & ~Escapable>(
        of coproduct: consuming Coproduct<repeat each Other, Inhabited>
    ) -> Inhabited
    where repeat each Other == Never {

        switch consume coproduct {
        case .at(let value):

            consume value
        }
    }

#endif
