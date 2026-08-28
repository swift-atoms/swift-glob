extension Glob {

    public struct Pattern: Sendable, Hashable {

        public let raw: Swift.String

        public let segments: [Segment]

        public let isRecursive: Bool

        @inlinable
        public init(
            raw: Swift.String,
            segments: [Segment],
            isRecursive: Swift.Bool
        ) {
            self.raw = raw
            self.segments = segments
            self.isRecursive = isRecursive
        }
    }
}
