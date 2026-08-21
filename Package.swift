// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-glob-primitives",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Glob Primitives",
            targets: ["Glob Primitives"]
        ),
        .library(
            name: "Glob Primitives Standard Library Integration",
            targets: ["Glob Primitives Standard Library Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-array-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-ownership-shared-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-buffer-linear-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-ascii-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-byte-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-byte-parser-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-parser-primitives.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Glob Primitives",
            dependencies: [
                .product(name: "Array Primitives", package: "swift-array-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitives",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
                .product(
                    name: "Byte Primitives Standard Library Integration",
                    package: "swift-byte-primitives"
                ),
                .product(name: "Byte Parser Primitives", package: "swift-byte-parser-primitives"),
                .product(name: "Parser Primitives", package: "swift-parser-primitives"),
            ]
        ),
        .target(
            name: "Glob Primitives Standard Library Integration",
            dependencies: [
                "Glob Primitives"
            ]
        ),
        .testTarget(
            name: "Glob Primitives Tests",
            dependencies: [
                "Glob Primitives"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
