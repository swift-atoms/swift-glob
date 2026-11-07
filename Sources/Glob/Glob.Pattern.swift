extension Glob {

    public struct Pattern: Sendable, Hashable {

        public let raw: Swift::String

        public let segments: [Segment]

        public let isRecursive: Bool

        @inlinable
        public init(
            raw: Swift::String,
            segments: [Segment]
        ) {
            self.raw = raw
            self.segments = segments
            self.isRecursive = segments.contains(.doubleStar)
        }
    }
}

#if Parser
    extension Glob.Pattern: ExpressibleByStringLiteral {

        @inlinable
        public init(stringLiteral value: Swift::String) {
            do throws(Glob.Error) {
                self = try Glob.Pattern.parse(value)
            } catch {
                fatalError("Glob.Pattern literal failed to parse: \(value): \(error)")
            }
        }
    }
#endif

#if Parser
    import Byte
    import Cursor
    import Parser

    extension Glob.Pattern {

        @inlinable
        public init(_ pattern: Swift::String) throws(Glob.Error) {
            self = try Self.parse(pattern)
        }

        @inlinable
        public static func parse(_ pattern: Swift::String) throws(Glob.Error) -> Self {
            var input = [Byte](utf8: pattern)[...]
            return try Self.Parser<ArraySlice<Byte>>().parse(&input)
        }
    }
#endif

#if Parser
    import Byte
    import Cursor
    import Parser

    extension Glob.Pattern {

        @inlinable
        public static var parser: Glob.Pattern.Parser<ArraySlice<Byte>> { Glob.Pattern.Parser<ArraySlice<Byte>>() }
    }
#endif
