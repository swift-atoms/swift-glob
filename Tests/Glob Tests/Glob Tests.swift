import Testing

@testable import Glob

extension Glob {
    @Suite struct Tests {
        @Suite struct Unit {}
    }
}

extension Glob.Tests.Unit {
    @Test
    func `Glob.isPattern detects metacharacters`() {
        #expect(Glob.isPattern("*.txt") == true)
        #expect(Glob.isPattern("file?.txt") == true)
        #expect(Glob.isPattern("[abc].txt") == true)
        #expect(Glob.isPattern("plain-file.txt") == false)
    }

    @Test
    func `Glob.Pattern memberwise values are preserved`() {
        let pattern = Glob.Pattern(
            raw: "file.txt",
            segments: [.literal(Swift.Array("file.txt".utf8))],
            isRecursive: false
        )
        #expect(pattern.raw == "file.txt")
        #expect(pattern.segments.count == 1)
        #expect(pattern.isRecursive == false)
    }
}
