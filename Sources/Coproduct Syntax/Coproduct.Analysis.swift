public import Type_Algebra_Syntax
public import SwiftSyntax

extension Coproduct {
    public struct Analysis {
        public struct Case {
            public let element: EnumCaseElementSyntax
            public let name: TokenSyntax
            public let parameters: [EnumCaseParameterSyntax]
            public let payload: TypeSyntax

            public init(_ element: EnumCaseElementSyntax) {
                self.element = element
                name = element.name
                parameters = element.parameterClause.map {
                    Array($0.parameters)
                } ?? []
                payload = Self.payload(of: parameters)
            }

            public func references(_ parameter: TokenSyntax) -> Bool {
                parameters.contains { parameterDeclaration in
                    Type.Syntax.Expression.references(in: parameterDeclaration.type, parameters: [parameter.text]).contains(parameter.text)
                }
            }

            public func isDirectReference(to parameter: TokenSyntax) -> Bool {
                guard
                    parameters.count == 1,
                    let identifier = parameters[0].type.as(IdentifierTypeSyntax.self)
                else { return false }
                return identifier.moduleSelector == nil
                    && identifier.genericArgumentClause == nil
                    && identifier.name.text == parameter.text
            }

            public func tupleLabel(at offset: Int) -> TokenSyntax? {
                Self.tupleLabel(of: parameters[offset])
            }

            public func constructorLabel(at offset: Int) -> TokenSyntax? {
                let first = parameters[offset].firstName
                return first?.tokenKind == .wildcard ? nil : first
            }

            // The spellings every derivation over a case shares: the pattern that binds its payload, the
            // constructor arguments that rebuild it, and the tuple expression that projects it.

            /// One binding name per parameter: `value0, value1, …` under the given stem.
            public func bindings(_ stem: String = "value") -> [String] {
                parameters.indices.map { "\(stem)\($0)" }
            }

            /// `.name`, `.name(value0)` or `.name(value0, value1)`: the pattern binding the payload.
            public func pattern(_ stem: String = "value") -> String {
                parameters.isEmpty ? ".\(name.text)" : "let .\(name.text)(\(bindings(stem).joined(separator: ", ")))"
            }

            /// The constructor arguments rebuilding the case from the given values, labelled as declared.
            public func constructorArguments(_ values: [String]) -> String {
                values.enumerated().map { offset, value in
                    constructorLabel(at: offset).map { "\($0.text): \(value)" } ?? value
                }.joined(separator: ", ")
            }

            /// The payload as one expression: `()`, the single value, or a labelled tuple of the values.
            public func payloadExpression(_ values: [String]) -> String {
                switch values.count {
                case 0: return "()"
                case 1: return values[0]
                default:
                    let elements = values.enumerated().map { offset, value in
                        tupleLabel(at: offset).map { "\($0.text): \(value)" } ?? value
                    }
                    return "(\(elements.joined(separator: ", ")))"
                }
            }

            private static func payload(
                of parameters: [EnumCaseParameterSyntax]
            ) -> TypeSyntax {
                switch parameters.count {
                case 0:
                    return TypeSyntax(
                        IdentifierTypeSyntax(name: .identifier("Void"))
                    )
                case 1:
                    return parameters[0].type
                default:
                    let elements = parameters.enumerated().map { offset, parameter in
                        let label = tupleLabel(of: parameter)
                        return TupleTypeElementSyntax(
                            firstName: label,
                            colon: label == nil ? nil : .colonToken(trailingTrivia: .space),
                            type: parameter.type,
                            trailingComma: offset == parameters.count - 1
                                ? nil
                                : .commaToken(trailingTrivia: .space)
                        )
                    }
                    return TypeSyntax(
                        TupleTypeSyntax(elements: TupleTypeElementListSyntax(elements))
                    )
                }
            }

            private static func tupleLabel(
                of parameter: EnumCaseParameterSyntax
            ) -> TokenSyntax? {
                if let first = parameter.firstName, first.tokenKind != .wildcard {
                    return first
                }
                if let second = parameter.secondName, second.tokenKind != .wildcard {
                    return second
                }
                return nil
            }
        }

        public var algebra: Type.Record {
            get throws {
                try Type.Record(cases.map { .init($0.name.text, Type.Syntax.Expression($0.payload, parameters: []).algebra) })
            }
        }

        public let declaration: EnumDeclSyntax?
        public let whole: TypeSyntax
        public let access: DeclModifierSyntax?
        public let cases: [Case]
        public let genericParameter: TokenSyntax?
        public let isCopyableSuppressed: Bool

        public init(_ declaration: EnumDeclSyntax) {
            let elements = declaration.memberBlock.members
                .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
                .flatMap(\.elements)
            self.init(
                declaration: declaration,
                whole: TypeSyntax(IdentifierTypeSyntax(name: declaration.name)),
                access: Self.access(of: declaration),
                cases: Array(elements),
                genericParameter: Self.unconstrainedParameter(of: declaration),
                isCopyableSuppressed: Self.suppressesCopyable(declaration)
            )
        }

        public init(
            whole: TypeSyntax,
            access: DeclModifierSyntax?,
            cases: [EnumCaseElementSyntax],
            genericParameter: TokenSyntax?,
            isCopyableSuppressed: Bool = false
        ) {
            self.init(
                declaration: nil,
                whole: whole,
                access: access,
                cases: cases,
                genericParameter: genericParameter,
                isCopyableSuppressed: isCopyableSuppressed
            )
        }

        private init(
            declaration: EnumDeclSyntax?,
            whole: TypeSyntax,
            access: DeclModifierSyntax?,
            cases: [EnumCaseElementSyntax],
            genericParameter: TokenSyntax?,
            isCopyableSuppressed: Bool
        ) {
            self.declaration = declaration
            self.whole = whole
            self.access = access
            self.cases = cases.map(Case.init)
            self.genericParameter = genericParameter
            self.isCopyableSuppressed = isCopyableSuppressed
        }

        private static func suppressesCopyable(
            _ declaration: EnumDeclSyntax
        ) -> Bool {
            declaration.inheritanceClause?.inheritedTypes.contains { inherited in
                guard
                    let suppressed = inherited.type.as(SuppressedTypeSyntax.self),
                    let identifier = suppressed.type.as(IdentifierTypeSyntax.self)
                else { return false }
                return identifier.moduleSelector == nil
                    && identifier.genericArgumentClause == nil
                    && identifier.name.text == "Copyable"
            } ?? false
        }

        private static func unconstrainedParameter(
            of declaration: EnumDeclSyntax
        ) -> TokenSyntax? {
            guard
                declaration.genericWhereClause == nil,
                let parameters = declaration.genericParameterClause?.parameters,
                parameters.count == 1,
                let parameter = parameters.first,
                parameter.attributes.isEmpty,
                parameter.specifier == nil,
                parameter.colon == nil,
                parameter.inheritedType == nil
            else { return nil }
            return parameter.name
        }

        private static func access(
            of declaration: EnumDeclSyntax
        ) -> DeclModifierSyntax? {
            for modifier in declaration.modifiers {
                switch modifier.name.tokenKind {
                case .keyword(.public), .keyword(.package), .keyword(.fileprivate):
                    return modifier
                case .keyword(.private):
                    return DeclModifierSyntax(name: .keyword(.fileprivate))
                default:
                    continue
                }
            }
            return nil
        }
    }
}
