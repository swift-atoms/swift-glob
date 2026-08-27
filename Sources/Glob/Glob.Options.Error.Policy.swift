extension Glob.Options.Error {

    public enum Policy: Sendable, Hashable {

        case fail

        case skip
    }
}
