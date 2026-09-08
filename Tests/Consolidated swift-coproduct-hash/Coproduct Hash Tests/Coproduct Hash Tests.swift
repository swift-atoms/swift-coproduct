import Coproduct
import Coproduct
import Hash
import Hash
import Testing

@Suite
struct `Coproduct Hash Tests` {

    #if hasFeature(VariadicEnum)

        typealias Value = Coproduct<Int, String>

        @Test
        func `Coproduct is natively hashable through the seam`() {
            let values: Set<Value> = [.at(1), .at("one"), .at(1)]

            #expect(values.count == 2)
        }

        @Test
        func `Coproduct supplies Hash's domain-typed value`() {
            func hash<T: Hash.`Protocol`>(_ value: borrowing T) -> Hash.Value {
                value.hashValue
            }

            let first: Hash.Value = hash(Value.at(1))
            let second: Hash.Value = hash(Value.at(1))
            #expect(first == second)
        }

    #else

        @Test("Variadic-enum hash integration is unavailable")
        func variadicEnumUnavailable() {
            #expect(Bool(true))
        }

    #endif
}
