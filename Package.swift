// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-glob",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Glob", targets: ["Glob"]),

        .library(name: "Glob Foundation Integration", targets: ["Glob Foundation Integration"]),
        .library(name: "Glob Test Support", targets: ["Glob Test Support"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-ascii.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Glob",
            dependencies: [
                .product(name: "ASCII", package: "swift-ascii"),
            ],
            path: "Sources/Glob"
        ),
        
        .target(
            name: "Glob Foundation Integration",
            dependencies: [
                .target(name: "Glob"),
            ],
            path: "Sources/Glob Foundation Integration"
        ),
        .target(
            name: "Glob Test Support",
            dependencies: [
                .target(name: "Glob"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Glob Tests",
            dependencies: [
                .target(name: "Glob"),
                .target(name: "Glob Test Support"),
                .target(name: "Glob Foundation Integration"),
            ],
            path: "Tests/Glob Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
