extension Glob {

    public enum Error: Swift.Error, Sendable, Hashable {

        case invalidPattern(pattern: Swift.String, position: Int, reason: Parse)

        case accessDenied(path: Swift.String)

        case notFound(path: Swift.String)

        case notDirectory(path: Swift.String)

        case io(path: Swift.String, category: IO)
    }
}
