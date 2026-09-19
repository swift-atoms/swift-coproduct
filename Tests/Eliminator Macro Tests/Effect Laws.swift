import Eliminator_Macro
import Testing
private enum Failure: Error { case selected }
@Eliminator(consuming: false, asynchronous: false, throwing: false)
private enum Choice000 { case value(Int) }
@Eliminator(consuming: false, asynchronous: false, throwing: true)
private enum Choice001 { case value(Int) }
@Eliminator(consuming: false, asynchronous: true, throwing: false)
private enum Choice010 { case value(Int) }
@Eliminator(consuming: false, asynchronous: true, throwing: true)
private enum Choice011 { case value(Int) }
@Eliminator(consuming: true, asynchronous: false, throwing: false)
private enum Choice100 { case value(Int) }
@Eliminator(consuming: true, asynchronous: false, throwing: true)
private enum Choice101 { case value(Int) }
@Eliminator(consuming: true, asynchronous: true, throwing: false)
private enum Choice110 { case value(Int) }
@Eliminator(consuming: true, asynchronous: true, throwing: true)
private enum Choice111 { case value(Int) }
@Test func eliminationSeparatesAllOwnershipAndEffectAxes() async throws {
    let e000 = Choice000.Eliminator<Int>(value: { $0 + 1 })
    #expect(e000(.value(3)) == 4)
    let e001 = Choice001.Eliminator<Int>(value: { $0 + 1 })
    #expect(try e001(.value(3)) == 4)
    let e010 = Choice010.Eliminator<Int>(value: { $0 + 1 })
    #expect(await e010(.value(3)) == 4)
    let e011 = Choice011.Eliminator<Int>(value: { $0 + 1 })
    #expect(try await e011(.value(3)) == 4)
    let e100 = Choice100.Eliminator<Int>(value: { $0 + 1 })
    #expect(e100(.value(3)) == 4)
    let e101 = Choice101.Eliminator<Int>(value: { $0 + 1 })
    #expect(try e101(.value(3)) == 4)
    let e110 = Choice110.Eliminator<Int>(value: { $0 + 1 })
    #expect(await e110(.value(3)) == 4)
    let e111 = Choice111.Eliminator<Int>(value: { $0 + 1 })
    #expect(try await e111(.value(3)) == 4)
}
@Test func throwingEliminationPreservesTheError() {
    let e = Choice001.Eliminator<Int>(value: { _ in throw Failure.selected })
    #expect(throws: Failure.self) { try e(.value(1)) }
}
