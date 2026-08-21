extension Glob.Options {

    public enum Ordering: Sendable, Hashable {

        case deterministic

        case filesystemOrder
    }
}
