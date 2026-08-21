public import Byte_Parser_Primitives
internal import Byte_Primitives_Standard_Library_Integration
import Collection_Primitives
public import Parser_Primitives

extension Glob.Pattern {

    public struct Parser<Input: Collection.Slice.`Protocol`>: Swift.Sendable
    where Input: Swift.Sendable, Input.Element == Byte {

        @inlinable
        public init() {}
    }
}

extension Glob.Pattern.Parser: Parser_Primitives.Parser.`Protocol` {

    public typealias Output = Glob.Pattern

    public typealias Failure = Glob.Error

    public typealias Body = Never

    public func parse(_ input: inout Input) throws(Glob.Error) -> Glob.Pattern {
        let bytes = input[input.startIndex..<input.endIndex]
        let patternString = Swift.String(decoding: bytes, as: Swift.UTF8.self)
        let parts = patternString.split(separator: "/", omittingEmptySubsequences: false)
        var compiledSegments: [Glob.Segment] = []
        var hasDoubleStar = false

        for (index, part) in parts.enumerated() {

            if part == "**" {
                compiledSegments.append(.doubleStar)
                hasDoubleStar = true
                continue
            }

            let partString = Swift.String(part)

            if !Glob.isPattern(partString) {
                compiledSegments.append(.literal(Swift.Array(part.utf8)))
                continue
            }

            let atoms = try Self.parseAtoms(partString, segmentIndex: index)
            compiledSegments.append(.pattern(atoms))
        }

        input = input[input.endIndex...]

        return Glob.Pattern(
            raw: patternString,
            segments: compiledSegments,
            isRecursive: hasDoubleStar
        )
    }

    @usableFromInline
    static func parseAtoms(
        _ segment: Swift.String,
        segmentIndex: Swift.Int
    ) throws(Glob.Error) -> [Glob.Atom] {
        var atoms: [Glob.Atom] = []
        var literal: [Swift.UInt8] = []
        var iterator = segment.unicodeScalars.makeIterator()
        var position = 0

        func flushLiteral() {
            if !literal.isEmpty {
                atoms.append(.literal(literal))
                literal = []
            }
        }

        while let scalar = iterator.next() {
            position += 1

            switch scalar {
            case "*":
                flushLiteral()
                atoms.append(.star)

            case "?":
                flushLiteral()
                atoms.append(.question)

            case "[":
                flushLiteral()
                let scalarClass = try parseScalarClass(
                    &iterator,
                    pattern: segment,
                    startPosition: position
                )
                atoms.append(.scalar(scalarClass))

            case "\\":

                guard let next = iterator.next() else {
                    throw .invalidPattern(
                        pattern: segment,
                        position: position,
                        reason: .unexpectedEnd
                    )
                }
                position += 1
                appendUTF8(next, to: &literal)

            default:
                appendUTF8(scalar, to: &literal)
            }
        }

        flushLiteral()
        return atoms
    }

    @usableFromInline
    static func appendUTF8(_ scalar: Unicode.Scalar, to bytes: inout [Swift.UInt8]) {
        let v = scalar.value
        if v < 0x80 {
            bytes.append(Swift.UInt8(truncatingIfNeeded: v))
        } else if v < 0x800 {
            bytes.append(Swift.UInt8(0xC0 | (v >> 6)))
            bytes.append(Swift.UInt8(0x80 | (v & 0x3F)))
        } else if v < 0x1_0000 {
            bytes.append(Swift.UInt8(0xE0 | (v >> 12)))
            bytes.append(Swift.UInt8(0x80 | ((v >> 6) & 0x3F)))
            bytes.append(Swift.UInt8(0x80 | (v & 0x3F)))
        } else {
            bytes.append(Swift.UInt8(0xF0 | (v >> 18)))
            bytes.append(Swift.UInt8(0x80 | ((v >> 12) & 0x3F)))
            bytes.append(Swift.UInt8(0x80 | ((v >> 6) & 0x3F)))
            bytes.append(Swift.UInt8(0x80 | (v & 0x3F)))
        }
    }

    @usableFromInline
    static func parseScalarClass(
        _ iterator: inout Swift.String.UnicodeScalarView.Iterator,
        pattern: Swift.String,
        startPosition: Swift.Int
    ) throws(Glob.Error) -> Glob.Scalar.Class {
        var position = startPosition
        var negated = false
        var scalars: Swift.Set<Swift.UInt32> = []
        var ranges: [Swift.ClosedRange<Swift.UInt32>] = []
        var previousScalar: Unicode.Scalar? = nil
        var expectingRangeEnd = false
        var hasContent = false

        guard let first = iterator.next() else {
            throw .invalidPattern(
                pattern: pattern,
                position: position,
                reason: .unterminatedClass
            )
        }
        position += 1
        if first == "!" || first == "^" {
            negated = true
        } else if first == "]" {

            throw .invalidPattern(
                pattern: pattern,
                position: position,
                reason: .emptyClass
            )
        } else {
            previousScalar = first
            scalars.insert(first.value)
            hasContent = true
        }

        while let scalar = iterator.next() {
            position += 1

            if scalar == "]" && (hasContent || negated) {

                if expectingRangeEnd {

                    scalars.insert(Unicode.Scalar("-").value)
                }
                return Glob.Scalar.Class(
                    negated: negated,
                    ranges: ranges,
                    scalars: scalars
                )
            }

            if scalar == "-" && previousScalar != nil {
                expectingRangeEnd = true
                continue
            }

            if expectingRangeEnd {

                if let start = previousScalar {
                    guard start.value <= scalar.value else {
                        throw .invalidPattern(
                            pattern: pattern,
                            position: position,
                            reason: .invalidRange
                        )
                    }
                    ranges.append(start.value...scalar.value)

                    scalars.remove(start.value)
                    hasContent = true
                }
                expectingRangeEnd = false
                previousScalar = nil
            } else {
                scalars.insert(scalar.value)
                previousScalar = scalar
                hasContent = true
            }
        }

        throw .invalidPattern(
            pattern: pattern,
            position: position,
            reason: .unterminatedClass
        )
    }
}
