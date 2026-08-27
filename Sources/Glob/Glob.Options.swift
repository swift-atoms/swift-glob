extension Glob {

    public struct Options: Sendable, Hashable {

        public var caseInsensitive: Bool

        public var dotfiles: Dotfile

        public var followSymlinks: Bool

        public var maxDepth: Int?

        public var ordering: Ordering

        public var onError: Error.Policy

        public init(
            caseInsensitive: Bool = false,
            dotfiles: Dotfile = .explicit,
            followSymlinks: Bool = false,
            maxDepth: Int? = nil,
            ordering: Ordering = .deterministic,
            onError: Error.Policy = .fail
        ) {
            self.caseInsensitive = caseInsensitive
            self.dotfiles = dotfiles
            self.followSymlinks = followSymlinks
            self.maxDepth = maxDepth
            self.ordering = ordering
            self.onError = onError
        }
    }
}
