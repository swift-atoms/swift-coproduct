import SwiftSyntax
import SwiftSyntaxMacros
import Eliminator_Macro_Core

public struct Macro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo _: [TypeSyntax],
        in _: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let declaration = declaration.as(EnumDeclSyntax.self) else {
            throw MacroExpansionErrorMessage("@Eliminator applies to an enum declaration only.")
        }
        let arguments = node.arguments?.as(LabeledExprListSyntax.self) ?? []
        func enabled(_ label: String) throws -> Bool {
            guard let expression = arguments.first(where: { $0.label?.text == label })?.expression else { return false }
            guard let literal = expression.as(BooleanLiteralExprSyntax.self) else {
                throw MacroExpansionErrorMessage("@Eliminator requires literal Boolean effect and ownership choices")
            }
            return literal.literal.text == "true"
        }
        return Eliminator.Derivation.expansion(
            of: declaration, consuming: try enabled("consuming"), asynchronous: try enabled("asynchronous"), throwing: try enabled("throwing")
        )
    }
}
