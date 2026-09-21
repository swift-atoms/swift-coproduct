import Type_Algebra_Syntax
public import SwiftSyntax
public import Coproduct_Syntax
import SwiftSyntaxBuilder

extension Eliminator {
    public enum Derivation {
        public static func expansion(
            of declaration: EnumDeclSyntax, consuming: Bool = false, asynchronous: Bool = false, throwing: Bool = false
        ) -> [DeclSyntax] {
            expansion(Coproduct.Analysis(declaration), consuming: consuming, asynchronous: asynchronous, throwing: throwing)
        }

        public static func expansion(_ analysis: Coproduct.Analysis, consuming: Bool = false, asynchronous: Bool = false, throwing: Bool = false) -> [DeclSyntax] {
            do { return try derive(analysis, consuming: consuming, asynchronous: asynchronous, throwing: throwing) }
            catch { return [DeclSyntax(stringLiteral: "#error(\(String(reflecting: String(describing: error))))")] }
        }

        private static func derive(_ analysis: Coproduct.Analysis, consuming: Bool, asynchronous: Bool, throwing: Bool) throws -> [DeclSyntax] {
            let result = Type.Expression.variable(.init("Result"))
            let alternatives = try analysis.algebra
            guard case .product(let arrows) = alternatives.eliminator(returning: result) else {
                throw Type.Failure("elimination must produce a product of handlers")
            }
            let convention = consuming ? "consuming" : "borrowing"
            let effects = (asynchronous ? " async" : "") + (throwing ? " throws" : "")
            let prefix = (throwing ? "try " : "") + (asynchronous ? "await " : "")
            let access = analysis.access.map { "\($0.name.text) " } ?? ""
            let interpreter = Type.Syntax.Interpretation(
                atoms: Dictionary(analysis.cases.map { (Type.Atom($0.payload.trimmedDescription, scope: ["Swift"]), $0.payload) }, uniquingKeysWith: { first, _ in first }),
                variables: [.init("Result"): TypeSyntax(stringLiteral: "Result")])
            let record = try Type.Syntax.Record(arrows.enumerated().map { index, arrow in
                guard case .exponential(let domain, let codomain) = arrow else { throw Type.Failure("expected handler arrow") }
                let item = analysis.cases[index]
                let output = try interpreter.type(codomain).trimmedDescription
                // Tuple labels and ownership belong to the Swift representation of the domain.
                let input = item.parameters.isEmpty ? "" : "\(convention) \(try interpreter.type(domain))"
                let type = "(\(input))\(effects) -> \(output)"
                return .init(alternatives.fields[index].name, type: type, argument: "@escaping " + type, mutable: false)
            })
            let stored = record.declarations(access: access).joined(separator: "\n")
            let initializer = try record.initializer(access: access)
            let branches = record.fields.enumerated().map { index, field in
                let item = analysis.cases[index]
                let argument = item.parameters.isEmpty ? "" : item.payloadExpression(item.bindings("payload"))
                return "case \(item.pattern("payload")): return \(prefix)self.\(field.name)(\(argument))"
            }.joined(separator: "\n")

            return ["""
                \(raw: access)struct Eliminator<Result: ~Copyable\(raw: asynchronous || consuming ? "" : " & ~Escapable")> {
                    \(raw: stored)

                    \(raw: initializer)

                    \(raw: asynchronous || consuming ? "" : "@_lifetime(borrow self, borrow value)")
                    \(raw: access)func callAsFunction(_ value: \(raw: convention) \(analysis.whole))\(raw: effects) -> Result {
                        \(raw: analysis.cases.isEmpty ? "" : "switch \(consuming ? "consume " : analysis.isCopyableSuppressed ? "" : "copy ")value {\n\(branches)\n}")
                    }
                }
                """]
        }

    }
}
