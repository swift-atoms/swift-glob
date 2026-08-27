public enum Glob {}

extension Glob {

    @inlinable
    public static func isPattern(_ string: Swift.String) -> Bool {
        for byte in string.utf8 {
            switch byte {
            case 0x2A, 0x3F, 0x5B, 0x5C:
                return true

            default:
                continue
            }
        }
        return false
    }
}
