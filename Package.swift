// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-coproduct",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Coproduct",
            targets: ["Coproduct"]
        ),
        .library(
            name: "Coproduct Standard Library Integration",
            targets: ["Coproduct Standard Library Integration"]
        ),
        .library(
            name: "Coproduct Apple Foundation Integration",
            targets: ["Coproduct Apple Foundation Integration"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Coproduct",
            dependencies: []
        ),
        .target(
            name: "Coproduct Standard Library Integration",
            dependencies: ["Coproduct"]
        ),
        .target(
            name: "Coproduct Apple Foundation Integration",
            dependencies: [
                "Coproduct",
                "Coproduct Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Coproduct Tests",
            dependencies: [
                "Coproduct"
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
