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

        public static func expansion(
            whole: TypeSyntax,
            access: DeclModifierSyntax?,
            cases: [EnumCaseElementSyntax]
        ) -> [DeclSyntax] {
            expansion(
                Coproduct.Analysis(
                    whole: whole,
                    access: access,
                    cases: cases,
                    genericParameter: nil
                )
            )
        }

        public static func expansion(_ analysis: Coproduct.Analysis, consuming: Bool = false, asynchronous: Bool = false, throwing: Bool = false) -> [DeclSyntax] {
            let convention = consuming ? "consuming" : "borrowing"
            let effects = (asynchronous ? " async" : "") + (throwing ? " throws" : "")
            let prefix = (throwing ? "try " : "") + (asynchronous ? "await " : "")
            let access = analysis.access.map { "\($0.name.text) " } ?? ""
            let escaping = analysis.cases.map { coproductCase in
                handler(
                    name: coproductCase.name.text,
                    payload: coproductCase.payload.trimmedDescription,
                    isNullary: coproductCase.parameters.isEmpty,
                    convention: convention, effects: effects,
                    escaping: true,
                    access: ""
                )
            }.joined(separator: ", ")
            let stored = analysis.cases.map { coproductCase in
                handler(
                    name: coproductCase.name.text,
                    payload: coproductCase.payload.trimmedDescription,
                    isNullary: coproductCase.parameters.isEmpty,
                    convention: convention, effects: effects,
                    escaping: false,
                    access: access
                )
            }.joined(separator: "\n")
            let assignments = analysis.cases.map {
                "self.\($0.name.text) = \($0.name.text)"
            }.joined(separator: "\n")
            let branches = analysis.cases.map { branch($0, prefix: prefix) }.joined(separator: "\n")

            return ["""
                \(raw: access)struct Eliminator<Result: ~Copyable\(raw: asynchronous || consuming ? "" : " & ~Escapable")> {
                    \(raw: stored)

                    \(raw: access)init(\(raw: escaping)) {
                        \(raw: assignments)
                    }

                    \(raw: asynchronous || consuming ? "" : "@_lifetime(borrow self, borrow value)")
                    \(raw: access)func callAsFunction(_ value: \(raw: convention) \(analysis.whole))\(raw: effects) -> Result {
                        switch \(raw: consuming ? "consume " : analysis.isCopyableSuppressed ? "" : "copy ")value {
                        \(raw: branches)
                        }
                    }
                }
                """]
        }

        private static func handler(
            name: String,
            payload: String,
            isNullary: Bool,
            convention: String, effects: String,
            escaping: Bool,
            access: String
        ) -> String {
            let type = isNullary ? "()\(effects) -> Result" : "(\(convention) \(payload))\(effects) -> Result"
            if escaping {
                return "\(name): @escaping \(type)"
            }
            return "\(access)let \(name): \(type)"
        }

        private static func branch(_ coproductCase: Coproduct.Analysis.Case, prefix: String) -> String {
            let name = coproductCase.name.text
            switch coproductCase.parameters.count {
            case 0:
                return "case .\(name): return \(prefix)self.\(name)()"
            case 1:
                return "case let .\(name)(payload): return \(prefix)self.\(name)(payload)"
            default:
                let payloads = coproductCase.parameters.indices.map { "payload\($0)" }
                let tuple = payloads.enumerated().map { offset, value in
                    coproductCase.tupleLabel(at: offset).map {
                        "\($0.text): \(value)"
                    } ?? value
                }.joined(separator: ", ")
                return "case let .\(name)(\(payloads.joined(separator: ", "))): return \(prefix)self.\(name)((\(tuple)))"
            }
        }
    }
}
