import Coproduct
import Testing

@Suite
struct `Coproduct exposes its module namespace` {
    @Suite struct `The Coproduct module imports successfully` {}
    @Suite struct `No coproduct namespace boundary cases are defined` {}
    @Suite struct `No coproduct namespace integration cases are defined` {}
    @Suite(.serialized) struct `No coproduct namespace performance cases are defined` {}
}

extension `Coproduct exposes its module namespace`.`The Coproduct module imports successfully` {
    @Test
    func `module imports cleanly`() {

    }
}
