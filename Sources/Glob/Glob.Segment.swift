extension Glob {

    public enum Segment: Sendable, Hashable {

        case literal([UInt8])

        case pattern([Atom])

        case doubleStar
    }
}
