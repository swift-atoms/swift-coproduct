import Comparison
import Coproduct
import Comparison
import Coproduct
import Testing

@Suite("Coproduct Comparison")
struct Coproduct_Comparison_Tests {

    #if hasFeature(VariadicEnum)

        typealias Value = Coproduct<Int, String>

        @Test("Coproduct satisfies Comparison.Protocol")
        func comparisonProtocolConformance() {
            requireComparisonProtocol(Value.self)
        }

        @Test("Values in the same alternative use their element ordering")
        func sameAlternativeOrdering() {
            let one: Value = .at(1)
            let two: Value = .at(2)
            let apple: Value = .at("apple")
            let banana: Value = .at("banana")

            #expect(one < two)
            #expect(!(two < one))
            #expect(apple < banana)
            #expect(!(banana < apple))
        }

        @Test("Equal active values compare equal")
        func equality() {
            let lhs: Value = .at(42)
            let rhs: Value = .at(42)

            #expect(lhs == rhs)
            #expect(!(lhs < rhs))
            #expect(!(rhs < lhs))
        }

        @Test("Different alternatives retain a total ordering")
        func alternativeOrdering() {
            let integer: Value = .at(1)
            let string: Value = .at("1")

            #expect(integer != string)
            #expect((integer < string) != (string < integer))
        }

    #else

        @Test("Variadic-enum integration is unavailable")
        func variadicEnumUnavailable() {
            #expect(Bool(true))
        }

    #endif
}

#if hasFeature(VariadicEnum)

    private func requireComparisonProtocol<T: Comparison.`Protocol`>(_: T.Type) {
    }

#endif
