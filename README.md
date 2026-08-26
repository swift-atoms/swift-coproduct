# Coproduct

![Development Status](https://img.shields.io/badge/status-experimental-red.svg)

`Coproduct<each Element>` — the n-ary coproduct type, a generic sum that holds exactly one value out of an arbitrary list of types. Where `Either` is the binary coproduct, `Coproduct` is its variadic generalization; the dual of `Product`'s n-ary cartesian product.

The package's source files declare `Coproduct<each Element>` and its operators inside `#if hasFeature(VariadicEnum)`. Swift 6.3.1 and Swift 6.4-dev reject parameter-pack enum cases with the `enum_with_pack` diagnostic ("enums cannot declare a type pack" — see `swift/test/Generics/variadic_generic_types.swift`); on these toolchains, importing `Coproduct` resolves to zero public symbols and the package builds clean. The API surface documented below activates only when an upstream toolchain defines `VariadicEnum` (or an equivalently-named gate). Refer to `Research/coproduct-primitive-design-and-blockers.md` for the blocker survey.

---

## Quick Start

The snippets below describe the API declared in the gated source files. They compile only on a toolchain where the feature gate is defined.

```swift
import Coproduct

// arity-3 coproduct over three error domains
let result: Coproduct<Lex.Error, Parse.Error, Validation.Error> =
    .at(Parse.Error.unexpectedToken)

// catamorphism — exactly one handler runs
let message = result.fold(
    { lex in "lex: \(lex)" },
    { parse in "parse: \(parse)" },
    { validation in "validation: \(validation)" }
)
// "parse: ..."
```

### Multi-cause typed throws on the input side

```swift
enum Lex        { struct Error: Swift.Error {} }
enum Parse      { struct Error: Swift.Error {} }
enum Validation { struct Error: Swift.Error {} }

// Throws one of three error types — dual of Product's multi-cause aggregation.
func parse(_ s: String) throws(Coproduct<Lex.Error, Parse.Error, Validation.Error>) -> AST {
    // ... throw .at(Parse.Error.unexpectedToken) ...
}
```

### Transforming the active arm

```swift
let c: Coproduct<Int, String, Bool> = .at("hi")

let transformed = try c.map(
    { $0 + 1 },             // arm 0
    { $0.uppercased() },    // arm 1 — runs, only this position is active
    { !$0 }                 // arm 2
)
// Coproduct<Int, String, Bool> = .at("HI")
```

### Never elimination

When every arm but one is `Never`, the inhabited value extracts unconditionally:

```swift
let c: Coproduct<Never, Int, Never> = .at(42)
let v = value(of: c)   // 42 — every other arm is uninhabited
```

### Lifecycle and ~Escapable arms

`Coproduct` is a *movement vehicle* — it transports one of N alternative values. It does not close, unlock, or otherwise act on its arm on drop; lifecycle decisions belong to the consumer, typically via `fold` or `value(of:)` extraction.

Each arm carries `~Copyable & ~Escapable` suppressions on the pack constraint. Parameter packs do not yet admit `each T: ~Copyable` or `each T: ~Escapable` in Swift 6.3.1 or 6.4-dev (`swift/test/Generics/inverse_copyable_requirement_errors.swift` enforces the rejection on `packingUniqueHeat_1` / `packingUniqueHeat_2`); the same cohort blocker gates `swift-product` from move-only arms. Closure-bearing methods (`map`, `fold`, `flatMap`) admit `~Escapable` on the un-transformed arms only, mirroring `Either`'s closure constraint.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-molecules/swift-coproduct.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Coproduct", package: "swift-coproduct"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain). On current toolchains, importing `Coproduct` resolves to zero public symbols.

---

## Architecture

One library product, one target.

| Product | Target | Contents |
|---------|--------|----------|
| `Coproduct` | `Sources/Coproduct/` | `Coproduct<each Element>` (variadic over parameter packs) + n-ary `fold` / `map` / `flatMap` instance + static methods + free `swapped(_:)` for n=2 + free `value(of:)` for single-arm-inhabited packs + conditional `Sendable` / `Equatable` / `Hashable` / `Comparable` / `CustomStringConvertible` / `Encodable` / `Decodable` / `Swift.Error` conformances. All declarations are gated `#if hasFeature(VariadicEnum)`. |
Dependencies: `swift-equation`, `swift-hash`, `swift-comparison`. Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Builds clean; no public symbols on current toolchains |
| Linux | Builds clean; no public symbols on current toolchains |
| Windows | Builds clean; no public symbols on current toolchains |
| iOS / tvOS / watchOS / visionOS | Builds clean; no public symbols on current toolchains |
| Swift Embedded | Builds clean; no public symbols on current toolchains. `Codable` declarations are gated `#if !hasFeature(Embedded)` |

---

## Related Packages

### Dependencies

- [swift-equation](https://github.com/swift-molecules/swift-equation) — institute `Equation.Protocol`.
- [swift-hash](https://github.com/swift-molecules/swift-hash) — institute `Hash.Protocol`.
- [swift-comparison](https://github.com/swift-molecules/swift-comparison) — institute `Comparison.Protocol`.

### Cohort siblings

- [swift-pair](https://github.com/swift-molecules/swift-pair) — binary product.
- [swift-either](https://github.com/swift-molecules/swift-either) — binary coproduct.
- [swift-product](https://github.com/swift-molecules/swift-product) — n-ary product.

---

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
