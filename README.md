# swift-glob

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Glob pattern types for matching paths against POSIX wildcards, recursive `**` segments, and Unicode-scalar character classes.

---

## Quick Start

A pattern is parsed once into path-split segments and then inspected. `Glob.isPattern` answers the cheap question — does this string contain glob metacharacters at all — before you commit to a parse:

```swift
import Glob

// Cheap pre-check: does this string contain glob metacharacters?
Glob.isPattern("src/**/*.swift")   // true
Glob.isPattern("README.md")        // false

// Parse into compiled, path-split segments.
let pattern = try Glob.Pattern("src/**/*.swift")
pattern.raw            // "src/**/*.swift"
pattern.isRecursive    // true — the pattern contains **
pattern.segments.count // 3 — "src", "**", "*.swift"

// Character classes match over Unicode scalar values.
let lowercase = Glob.Scalar.Class(
    negated: false,
    ranges: [0x61...0x7A],   // a–z
    scalars: []
)
lowercase.matches("m")   // true
lowercase.matches("M")   // false
```

The standard-library integration product adds an `ExpressibleByStringLiteral` conformance, so a pattern known at the call site reads as a plain literal and is parsed eagerly when the literal is loaded:

```swift
import Glob_Standard_Library_Integration

let recursive: Glob.Pattern = "src/**/*.swift"   // parsed at the literal site
```

The grammar is `*` (any run of characters within a segment), `**` (zero or more path segments), `?` (one Unicode scalar), and `[abc]` / `[!abc]` / `[^abc]` (scalar classes). Backslash escapes the following character. Brace expansion `{a,b,c}` is shell policy, not glob core, and is left to a higher layer.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-molecules/swift-glob.git", branch: "main")
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Glob", package: "swift-glob"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Two library products. Foundation-free.

| Product | Import | Purpose |
|---------|--------|---------|
| `Glob` | `Glob` | The `Glob` namespace and its vocabulary: `Glob.Pattern` and its byte-stream `Glob.Pattern.Parser`, the `Glob.Segment` / `Glob.Atom` / `Glob.Scalar.Class` building blocks, `Glob.Options`, and the typed `Glob.Error` family. |
| `Glob Standard Library Integration` | `Glob_Standard_Library_Integration` | Re-exports the core target and adds the `ExpressibleByStringLiteral` conformance on `Glob.Pattern`. |

Import the narrowest product you need: `Glob` for the pattern types alone, or `Glob Standard Library Integration` (which `@_exported public import`s the core target) when you want glob patterns to read as string literals.

Literal content is stored as UTF-8 bytes in `Glob.Segment` and `Glob.Atom`, so platform match implementations compare against filesystem entries without an intermediate `String` allocation.

---

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at first public release.*
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE](LICENSE.md).
