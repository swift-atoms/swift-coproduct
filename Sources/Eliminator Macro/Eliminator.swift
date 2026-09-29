@attached(member, names: named(Eliminator))
public macro Eliminator(consuming: Bool = false, asynchronous: Bool = false, throwing: Bool = false) = #externalMacro(
    module: "Eliminator_Macro_Plugin",
    type: "Macro"
)
