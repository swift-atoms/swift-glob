# swift-glob

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Glob pattern types for matching paths against POSIX wildcards, recursive `**` segments, and Unicode-scalar character classes.

---

## Quick Start

A pattern is a value of path-split segments. `Glob.isPattern` answers the cheap question — does this string contain glob metacharacters at all:

```swift
import Glob

// Cheap pre-check: does this string contain glob metacharacters?
Glob.isPattern("src/**/*.swift")   // true
Glob.isPattern("README.md")        // false

// Character classes match over Unicode scalar values.
let lowercase = Glob.Scalar.Class(
    negated: false,
    ranges: [0x61...0x7A],   // a–z
    scalars: []
)
lowercase.matches("m")   // true
lowercase.matches("M")   // false
```

Parsing a pattern string into a `Glob.Pattern` — including the `ExpressibleByStringLiteral` conformance — lives in the `swift-glob-parser` molecule package.

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

Three library products. Dependency-free.

| Product | Import | Purpose |
|---------|--------|---------|
| `Glob` | `Glob` | The `Glob` namespace and its vocabulary: `Glob.Pattern`, the `Glob.Segment` / `Glob.Atom` / `Glob.Scalar.Class` building blocks, `Glob.Options`, and the typed `Glob.Error` family. |
| `Glob Standard Library Integration` | `Glob_Standard_Library_Integration` | Swift standard library conformances and extensions for the `Glob` domain. |
| `Glob Apple Foundation Integration` | `Glob_Apple_Foundation_Integration` | Foundation-facing integration; the only module permitted to import Foundation. |

Parsing pattern strings via the parser ecosystem lives in the `swift-glob-parser` molecule package.

Literal content is stored as UTF-8 bytes in `Glob.Segment` and `Glob.Atom`, so platform match implementations compare against filesystem entries without an intermediate `String` allocation.

---

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at first public release.*
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE](LICENSE.md).
