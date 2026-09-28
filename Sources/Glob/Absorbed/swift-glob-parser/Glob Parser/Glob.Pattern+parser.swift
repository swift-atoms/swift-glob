#if Parser
import Byte
import Cursor
import Parser

extension Glob.Pattern {


    @inlinable
    public static var parser: Glob.Pattern.Parser<ArraySlice<Byte>> { Glob.Pattern.Parser<ArraySlice<Byte>>() }
}
#endif
