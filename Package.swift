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
        .library(
            name: "Glob",
            targets: ["Glob"]
        ),
        .library(
            name: "Glob Standard Library Integration",
            targets: ["Glob Standard Library Integration"]
        ),
        .library(
            name: "Glob Apple Foundation Integration",
            targets: ["Glob Apple Foundation Integration"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Glob",
            dependencies: []
        ),
        .target(
            name: "Glob Standard Library Integration",
            dependencies: [
                "Glob"
            ]
        ),
        .target(
            name: "Glob Apple Foundation Integration",
            dependencies: [
                "Glob",
                "Glob Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Glob Tests",
            dependencies: [
                "Glob"
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
