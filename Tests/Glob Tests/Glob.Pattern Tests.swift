import Testing

@testable import Glob

extension Glob.Pattern {
    @Suite struct `Glob patterns retain their text and distinguish literal from pattern syntax` {
        @Suite struct `Glob literals retain their text representation` {}
        @Suite struct `Glob patterns detect metacharacters and preserve equality and hashing` {}
    }
}

extension Glob.Pattern.`Glob patterns retain their text and distinguish literal from pattern syntax`.`Glob literals retain their text representation` {
    @Test
    func `literal pattern retains its representation`() {
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

extension Glob.Pattern.`Glob patterns retain their text and distinguish literal from pattern syntax`.`Glob patterns detect metacharacters and preserve equality and hashing` {
    @Test
    func `Glob.isPattern detects metacharacters`() {
        #expect(Glob.isPattern("*.txt") == true)
        #expect(Glob.isPattern("file?.txt") == true)
        #expect(Glob.isPattern("[abc].txt") == true)
        #expect(Glob.isPattern("plain-file.txt") == false)
    }

    @Test
    func `equal patterns compare equal and hash equal`() {
        let a = Glob.Pattern(raw: "*.swift", segments: [.pattern([.star])], isRecursive: false)
        let b = Glob.Pattern(raw: "*.swift", segments: [.pattern([.star])], isRecursive: false)
        #expect(a == b)
        #expect(a.hashValue == b.hashValue)
    }
}
