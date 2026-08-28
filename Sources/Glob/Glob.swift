public import ASCII

public enum Glob {}

extension Glob {

    @inlinable
    public static func isPattern(_ string: Swift.String) -> Bool {
        for byte in string.utf8 {
            switch byte {
            case ASCII.Character.Graphic.asterisk,
                ASCII.Character.Graphic.questionMark,
                ASCII.Character.Graphic.leftBracket,
                ASCII.Character.Graphic.reverseSlant:
                return true

            default:
                continue
            }
        }
        return false
    }
}
