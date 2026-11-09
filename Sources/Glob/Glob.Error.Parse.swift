extension Glob.Error {

    public enum Parse: Sendable, Hashable {

        case unterminatedClass

        case invalidRange

        case unexpectedEnd

        case invalidEscape
    }
}
