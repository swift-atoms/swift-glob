import Testing

import Glob

extension Glob.Pattern {
    @Suite struct `Glob patterns retain their text and distinguish literal from pattern syntax` {
        @Suite struct `Glob literals retain their text representation` {}
        @Suite struct `Glob patterns detect metacharacters and preserve equality and hashing` {}
    }
}

extension Glob.Pattern.`Glob patterns retain their text and distinguish literal from pattern syntax`.`Glob literals retain their text representation` {
    @Test
    func `A literal pattern retains its supplied representation`() {
        let pattern = Glob.Pattern(
            raw: "file.txt",
            segments: [.literal(Swift.Array("file.txt".utf8))]
        )
        #expect(pattern.raw == "file.txt")
        #expect(pattern.segments.count == 1)
        #expect(pattern.isRecursive == false)
    }
}

extension Glob.Pattern.`Glob patterns retain their text and distinguish literal from pattern syntax`.`Glob patterns detect metacharacters and preserve equality and hashing` {
    @Test
    func `Glob detects metacharacters in a pattern string`() {
        #expect(Glob.isPattern("*.txt") == true)
        #expect(Glob.isPattern("file?.txt") == true)
        #expect(Glob.isPattern("[abc].txt") == true)
        #expect(Glob.isPattern("plain-file.txt") == false)
    }

    @Test
    func `Equal patterns compare equally and produce equal hashes`() {
        let a = Glob.Pattern(raw: "*.swift", segments: [.pattern([.star])])
        let b = Glob.Pattern(raw: "*.swift", segments: [.pattern([.star])])
        #expect(a == b)
        #expect(a.hashValue == b.hashValue)
    }
}

@Suite
struct `Compiled segments determine whether a glob pattern is recursive` {
    @Test
    func `Literal stars and ordinary pattern atoms do not request recursion`() {
        let representations: [[Glob.Segment]] = [
            [],
            [.literal([42, 42])],
            [.pattern([.star, .star])],
            [.pattern([.literal([42, 42])])],
            [.pattern([.question, .scalar(.init(negated: false, ranges: [], scalars: [42]))])],
        ]
        let raw = "**/source/**"
        for segments in representations {
            let pattern = Glob.Pattern(raw: raw, segments: segments)
            #expect(!pattern.isRecursive)
            #expect(pattern.raw == raw)
            #expect(pattern.segments == segments)
        }
    }

    @Test(arguments: [0, 1, 2])
    func `A recursive segment requests recursion at every position`(position: Int) {
        var segments: [Glob.Segment] = [.literal(Array("source".utf8)), .pattern([.star])]
        segments.insert(.doubleStar, at: position)
        let pattern = Glob.Pattern(raw: "source", segments: segments)
        #expect(pattern.isRecursive)
        #expect(pattern.raw == "source")
        #expect(pattern.segments == segments)
    }

    @Test
    func `Repeated recursive segments preserve the supplied representation`() {
        let segments: [Glob.Segment] = [.doubleStar, .doubleStar, .literal([]), .doubleStar]
        let pattern = Glob.Pattern(raw: "**//**", segments: segments)
        #expect(pattern.isRecursive)
        #expect(pattern.raw == "**//**")
        #expect(pattern.segments == segments)
    }
}
