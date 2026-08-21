extension Glob.Error {

    public enum IO: Sendable, Hashable {

        case read

        case tooManyOpenFiles

        case nameTooLong

        case loopDetected

        case other
    }
}
