public import Array_Primitives
public import Buffer_Linear_Primitive
public import Buffer_Linear_Primitives
public import Byte_Parser_Primitives
public import Ownership_Shared_Primitive
import Parser_Primitives

extension Glob {

    public struct Pattern: Sendable, Hashable {

        public let raw: Swift.String

        public let segments: [Segment]

        public let isRecursive: Bool
    }
}

extension Glob.Pattern {

    @inlinable
    public init(_ pattern: Swift.String) throws(Glob.Error) {
        var input = Byte.Input(utf8: pattern)
        self = try Self.Parser<Byte.Input>().parse(&input)
    }
}
