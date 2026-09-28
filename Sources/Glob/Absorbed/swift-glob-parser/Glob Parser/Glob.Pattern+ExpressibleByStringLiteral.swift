#if Parser
extension Glob.Pattern: ExpressibleByStringLiteral {

    @inlinable
    public init(stringLiteral value: Swift.String) {
        do throws(Glob.Error) {
            self = try Glob.Pattern.parse(value)
        } catch {
            fatalError("Glob.Pattern literal failed to parse: \(value): \(error)")
        }
    }
}
#endif
