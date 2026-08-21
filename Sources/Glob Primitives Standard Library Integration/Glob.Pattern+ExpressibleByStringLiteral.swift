public import Glob_Primitives

extension Glob.Pattern: ExpressibleByStringLiteral {

    @inlinable
    public init(stringLiteral value: Swift.String) {
        do throws(Glob.Error) {
            self = try Glob.Pattern(value)
        } catch {
            fatalError("Glob.Pattern literal failed to parse: \(value): \(error)")
        }
    }
}
