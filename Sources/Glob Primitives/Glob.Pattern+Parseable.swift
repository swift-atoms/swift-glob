public import Array_Primitives
public import Buffer_Linear_Primitive
public import Buffer_Linear_Primitives
public import Byte_Parser_Primitives
public import Ownership_Shared_Primitive
import Parser_Primitives

extension Glob.Pattern: Parseable {

    @_implements(Parseable,Parser)
    public typealias _ParseableParser = Glob_Primitives.Glob.Pattern.Parser<Byte.Input>

    @inlinable
    public static var parser: _ParseableParser { _ParseableParser() }
}
