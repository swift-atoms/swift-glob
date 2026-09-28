#if Parser
import Byte
import Cursor
import Parser

extension Glob.Pattern {

    @inlinable
    public init(_ pattern: Swift.String) throws(Glob.Error) {
        self = try Self.parse(pattern)
    }

    @inlinable
    public static func parse(_ pattern: Swift.String) throws(Glob.Error) -> Self {
        var input = [Byte](utf8: pattern)[...]
        return try Self.Parser<ArraySlice<Byte>>().parse(&input)
    }
}
#endif
