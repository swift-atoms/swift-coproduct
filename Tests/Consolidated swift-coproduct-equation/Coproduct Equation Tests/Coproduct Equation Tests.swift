import Coproduct
import Equation
import Testing

@Suite
struct `Coproduct Equation Tests` {
    @Test
    func `module imports cleanly`() {
    }

    #if hasFeature(VariadicEnum)

        @Test
        func `Coproduct satisfies Equation Protocol conditionally`() {
            func acceptsEquationProtocol<T: Equation.`Protocol`>(_ value: T) -> T {
                value
            }

            let value: Coproduct<Int, String> = .at(1)
            #expect(acceptsEquationProtocol(value) == value)
        }

        @Test
        func `Matching cases compare their payloads`() {
            let first: Coproduct<Int, String> = .at("value")
            let second: Coproduct<Int, String> = .at("value")
            let different: Coproduct<Int, String> = .at("other")

            #expect(first == second)
            #expect(first != different)
        }

        @Test
        func `Different cases compare unequal`() {
            let integer: Coproduct<Int, String> = .at(1)
            let string: Coproduct<Int, String> = .at("1")

            #expect(integer != string)
        }

    #endif
}
