# swift-glob

Use this package when you need a glob pattern as a value: to compile pattern text such as `Sources/**/*.swift` into path segments, to tell pattern text from a plain path with `Glob.isPattern(_:)`, or to carry `Glob.Options` and `Glob.Error` between the code that writes a pattern and the code that applies it. Start from `Glob.Pattern`, built with `Glob.Pattern.parse(_:)` or streamed from a byte cursor by `Glob.Pattern.Parser`. This package does not match paths or walk directories. For that, use the directory glob in swift-file-system, which consumes these values.

## Laws

- Parsing splits the text on every `/` and keeps empty parts, so `Sources//x` has an empty `Glob.Segment.literal` in the middle. `Glob.Pattern.raw` is always the input text, unchanged.
- Only a segment that is exactly `**` becomes `Glob.Segment.doubleStar`. A `**` inside a longer segment, `***`, and `\*\*` are ordinary stars or literals. `Glob.Pattern.isRecursive` is true exactly when at least one segment is `Glob.Segment.doubleStar`, however the pattern was built.
- A segment with none of `*`, `?`, `[`, `\` stays a `Glob.Segment.literal`. Any other segment becomes `Glob.Segment.pattern`. `{`, `}` and `]` outside a class are literal text: there is no brace expansion.
- `\` makes the next scalar literal. A trailing `\` is an `unexpectedEnd` failure.
- In a class, a first `!` or `^` negates it. A `]` right after `[` is an `emptyClass` failure, so `]` cannot be a member. A `-` directly before the closing `]` is a literal member. A range whose start is above its end is `invalidRange`. A class with no closing `]` is `unterminatedClass`.
- In `Glob.Error.invalidPattern`, `pattern` is the failing segment, not the whole text, and `position` is a 1-based Unicode-scalar offset into that segment.
- `Glob.Pattern.Parser` consumes all remaining input when it succeeds. When it fails, it restores the cursor to where parsing started.
- A `Glob.Pattern` string literal that fails to parse stops the program.
