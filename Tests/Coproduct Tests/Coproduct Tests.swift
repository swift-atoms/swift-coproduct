import Coproduct
import Testing

@Suite
struct `Coproduct Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `Coproduct Tests`.Unit {
    @Test
    func `module imports cleanly`() {

    }
}
