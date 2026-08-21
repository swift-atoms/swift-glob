extension Glob {

    public enum Atom: Sendable, Hashable {

        case literal([UInt8])

        case star

        case question

        case scalar(Scalar.Class)
    }
}
