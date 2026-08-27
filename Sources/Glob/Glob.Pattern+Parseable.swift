public import Array
public import Buffer_Linear_Primitive
public import Buffer_Linear
public import Byte_Parser
public import Ownership_Shared_Primitive
import Parser

extension Glob.Pattern: Parseable {

    @_implements(Parseable,Parser)
    public typealias _ParseableParser = Glob.Glob.Pattern.Parser<Byte.Input>

    @inlinable
    public static var parser: _ParseableParser { _ParseableParser() }
}
