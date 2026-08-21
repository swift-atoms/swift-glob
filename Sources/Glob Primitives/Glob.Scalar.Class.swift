extension Glob.Scalar {

    public struct Class: Sendable, Hashable {

        public let negated: Bool

        public let ranges: [ClosedRange<UInt32>]

        public let scalars: Set<UInt32>

        public init(
            negated: Bool,
            ranges: [ClosedRange<UInt32>],
            scalars: Set<UInt32>
        ) {
            self.negated = negated
            self.ranges = ranges
            self.scalars = scalars
        }
    }
}

extension Glob.Scalar.Class {

    @inlinable
    public func matches(_ scalar: Unicode.Scalar) -> Bool {
        let value = scalar.value
        let inClass = scalars.contains(value) || ranges.contains { $0.contains(value) }
        return negated ? !inClass : inClass
    }
}
