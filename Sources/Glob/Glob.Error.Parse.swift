extension Glob.Error {

    public enum Parse: Sendable, Hashable {

        case unterminatedClass

        case emptyClass

        case invalidRange

        case unexpectedEnd

        case invalidEscape
    }
}
