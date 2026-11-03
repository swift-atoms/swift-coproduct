# swift-coproduct

Use this package when a value is one of several alternatives and you need to take it apart exhaustively: attach `@Eliminator` to your own enum to get a nested `Eliminator` struct, generic over `Result`, that holds one handler per case and applies the matching one. Use `Coproduct<each Element>` when the alternatives are positional rather than named; it and its operations exist only on a compiler with the experimental `VariadicEnum` feature. Macro authors who need the shape of an enum's cases start from `Coproduct.Analysis` and `Eliminator.Derivation`. For exactly two unnamed alternatives use the Either type from swift-either; for components rather than alternatives use swift-product.

## Laws

- The generated `Eliminator` has one handler per enum case, labelled with the case name, in declaration order, and constructing it without every handler does not compile.
- A handler receives its case's payload: nothing for a case without payload, the payload itself for one parameter, and one tuple for several parameters that keeps each parameter's label (its first name, else its second name).
- Calling the eliminator runs exactly the handler of the value's case and returns that handler's result. By default the value is borrowed; with `consuming: true` it is consumed and passed on consuming. A noncopyable enum is borrowed without a copy.
- `Result` may always be noncopyable. It may be nonescapable only when neither `consuming:` nor `asynchronous:` is `true`; its lifetime is then tied to the borrows of the eliminator and the value.
- With `throwing: true` handlers may throw and the eliminator rethrows the handler's error unchanged; with `asynchronous: true` handlers are awaited. The two options and `consuming:` combine independently.
- An enum with no cases gets an eliminator with no handlers, constructible for any `Result`.
- The generated struct takes the enum's `public`, `package` or `fileprivate` access; a `private` enum yields `fileprivate`, any other enum yields the default access.
- `@Eliminator` on anything but an enum is diagnosed, and its options must be Boolean literals. If the case payloads cannot be read as a type algebra, the expansion is a `#error` carrying the reason instead of the struct.
- `Coproduct.Analysis` reports a `genericParameter` only for an enum with exactly one generic parameter that has no constraint, attribute or `where` clause.
- `Coproduct.Analysis.Case.references(_:)` is semantic: a qualified member such as `Qualified.Value` does not reference a parameter named `Value`. `isDirectReference(to:)` holds only when the single payload is that bare parameter.
- A case's `payload` is `Void` without parameters, the parameter type for one, and a labelled tuple for several.
