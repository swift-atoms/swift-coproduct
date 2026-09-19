/// Ownership, suspension, and failure are independent properties of elimination.
@attached(member, names: named(Eliminator))
public macro Eliminator(consuming: Bool = false, asynchronous: Bool = false, throwing: Bool = false) = #externalMacro(
    module: "Eliminator_Macro_Plugin",
    type: "Macro"
)
