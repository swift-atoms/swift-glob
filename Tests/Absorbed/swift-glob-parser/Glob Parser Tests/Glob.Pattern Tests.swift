#if Parser
import Testing

import Byte
import Cursor
import Glob
import Parser

extension Glob.Pattern {
    @Suite struct `Parsing glob patterns preserves their compiled representation` {
        @Suite struct `Ordinary glob syntax produces compiled segments` {}
        @Suite struct `Empty and malformed syntax produces the declared result` {}
        @Suite struct `Parser entry points preserve input and value semantics` {}
    }
}

extension Glob.Pattern.`Parsing glob patterns preserves their compiled representation`.`Ordinary glob syntax produces compiled segments` {
    @Test
    func `A literal pattern retains its text and one nonrecursive segment`() throws {
        let pattern = try Glob.Pattern.parse("file.txt")
        #expect(pattern.raw == "file.txt")
        #expect(pattern.segments.count == 1)
        #expect(pattern.isRecursive == false)
    }

    @Test
    func `A single star wildcard produces one nonrecursive segment`() throws {
        let pattern = try Glob.Pattern.parse("*.swift")
        #expect(pattern.segments.count == 1)
        #expect(pattern.isRecursive == false)
    }

    @Test
    func `A double star segment makes the parsed pattern recursive`() throws {
        let pattern = try Glob.Pattern.parse("**/*.txt")
        #expect(pattern.isRecursive == true)
    }

    @Test
    func `Path separators divide the source into segments`() throws {
        let pattern = try Glob.Pattern.parse("Sources/*/Tests")
        #expect(pattern.segments.count == 3)
    }
}

extension Glob.Pattern.`Parsing glob patterns preserves their compiled representation`.`Empty and malformed syntax produces the declared result` {
    @Test
    func `An empty source string retains its empty representation`() throws {
        let pattern = try Glob.Pattern.parse("")
        #expect(pattern.raw.isEmpty)
    }

    @Test
    func `An unterminated bracket class throws a glob error`() {
        #expect(throws: Glob.Error.self) {
            _ = try Glob.Pattern.parse("[abc")
        }
    }
}

extension Glob.Pattern.`Parsing glob patterns preserves their compiled representation`.`Parser entry points preserve input and value semantics` {
    @Test
    func `Successful parsing consumes the supplied byte slice`() throws(any Swift.Error) {
        let bytes = [Byte](utf8: "xxSources/**/*.swift")
        var input = bytes[2...]

        let pattern = try Glob.Pattern.parser.parse(&input)

        #expect(pattern.raw == "Sources/**/*.swift")
        #expect(pattern.isRecursive)
        #expect(input.isEmpty)
        #expect(input.startIndex == bytes.endIndex)
    }

    @Test
    func `Failed parsing restores the original byte slice and position`() {
        let bytes = [Byte](utf8: "xx[abc")
        var input = bytes[2...]
        let original = input

        #expect(throws: Glob.Error.self) {
            _ = try Glob.Pattern.parser.parse(&input)
        }

        #expect(input.count == 4)
        #expect(Array(input) == Array(original))
        #expect(input.startIndex == original.startIndex)
        #expect(input.endIndex == original.endIndex)
    }

    @Test
    func `Equal parsed patterns compare equally and produce equal hashes`() throws {
        let a = try Glob.Pattern.parse("*.swift")
        let b = try Glob.Pattern.parse("*.swift")
        #expect(a == b)
        #expect(a.hashValue == b.hashValue)
    }
}

extension Glob.Pattern.`Parsing glob patterns preserves their compiled representation`.`Ordinary glob syntax produces compiled segments` {
    @Test
    func `Whole double star segments retain their recursive positions`() throws {
        let cases: [(source: String, segments: [Glob.Segment])] = [
            ("**", [.doubleStar]),
            ("**/tail", [.doubleStar, .literal(Array("tail".utf8))]),
            ("head/**", [.literal(Array("head".utf8)), .doubleStar]),
            ("head/**/tail", [.literal(Array("head".utf8)), .doubleStar, .literal(Array("tail".utf8))]),
            ("**/**", [.doubleStar, .doubleStar]),
        ]
        for (source, segments) in cases {
            let pattern = try Glob.Pattern.parse(source)
            #expect(pattern.raw == source)
            #expect(pattern.segments == segments)
            #expect(pattern.isRecursive)
        }
    }

    @Test
    func `Embedded and escaped stars do not become recursive segments`() throws {
        let cases: [(source: String, atoms: [Glob.Atom])] = [
            ("**.swift", [.star, .star, .literal(Array(".swift".utf8))]),
            ("file**", [.literal(Array("file".utf8)), .star, .star]),
            ("***", [.star, .star, .star]),
            (#"\*\*"#, [.literal([42, 42])]),
            ("[*]", [.scalar(.init(negated: false, ranges: [], scalars: [42]))]),
        ]
        for (source, atoms) in cases {
            let pattern = try Glob.Pattern.parse(source)
            #expect(pattern.raw == source)
            #expect(pattern.segments == [.pattern(atoms)])
            #expect(!pattern.isRecursive)
        }
    }
}

extension Glob.Pattern.`Parsing glob patterns preserves their compiled representation`.`Parser entry points preserve input and value semantics` {
    @Test
    func `All parser entry points preserve the supplied representation`() throws {
        let source = "Sources//**/*.swift"
        let parsed = try Glob.Pattern.parse(source)
        let initialized = try Glob.Pattern(source)
        let literal: Glob.Pattern = "Sources//**/*.swift"
        var input = [Byte](utf8: source)[...]
        let streamed = try Glob.Pattern.parser.parse(&input)
        let segments: [Glob.Segment] = [
            .literal(Array("Sources".utf8)),
            .literal([]),
            .doubleStar,
            .pattern([.star, .literal(Array(".swift".utf8))]),
        ]
        for pattern in [parsed, initialized, literal, streamed] {
            #expect(pattern.raw == source)
            #expect(pattern.segments == segments)
            #expect(pattern.isRecursive)
        }
        #expect(input.isEmpty)
    }
}
#endif
