import Coproduct_Syntax
import SwiftParser
import SwiftSyntax
import Testing

@Test
func `analysis preserves payload syntax and finds semantic generic references`() throws {
    let source = Parser.parse(
        source: """
            private enum Choice<Value> {
                case value(payload: Value)
                case retained([Value])
                case qualified(Qualified.Value)
                case labeled(code: Int, note: String)
            }
            """
    )
    let declaration = try #require(
        source.statements.first?.item.as(EnumDeclSyntax.self)
    )
    let analysis = Coproduct.Analysis(declaration)
    let parameter = try #require(analysis.genericParameter)

    #expect(analysis.access?.name.tokenKind == .keyword(.fileprivate))
    #expect(
        analysis.cases.map(\.name.text) == [
            "value", "retained", "qualified", "labeled",
        ]
    )
    #expect(analysis.cases[0].isDirectReference(to: parameter))
    #expect(analysis.cases[1].references(parameter))
    #expect(!analysis.cases[2].references(parameter))
    #expect(
        analysis.cases[3].payload.trimmedDescription
            == "(code: Int, note: String)"
    )
}

@Test
func `analysis finds the cases inside conditional compilation blocks with their conditions`() throws {
    let source = Parser.parse(
        source: """
            enum Choice {
                case always
                #if canImport(SwiftUI)
                case view(Int)
                #if DEBUG
                case debugView
                #endif
                #elseif os(Linux)
                case linux
                #else
                case other
                #endif
            }
            """
    )
    let declaration = try #require(
        source.statements.first?.item.as(EnumDeclSyntax.self)
    )
    let analysis = Coproduct.Analysis(declaration)

    #expect(
        analysis.cases.map(\.name.text) == ["always", "view", "debugView", "linux", "other"]
    )
    #expect(
        analysis.cases.map(\.condition) == [
            nil,
            "(canImport(SwiftUI))",
            "(canImport(SwiftUI)) && (DEBUG)",
            "!(canImport(SwiftUI)) && (os(Linux))",
            "!(canImport(SwiftUI)) && !(os(Linux))",
        ]
    )
    #expect(!analysis.isSingleCase)
    #expect(analysis.cases[0].conditional("x") == "x")
    #expect(analysis.cases[2].conditional("x") == "#if (canImport(SwiftUI)) && (DEBUG)\nx\n#endif")
}
