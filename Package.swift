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
        .library(name: "Coproduct", targets: ["Coproduct"]),

        .library(name: "Coproduct Foundation Integration", targets: ["Coproduct Foundation Integration"]),
        .library(name: "Coproduct Test Support", targets: ["Coproduct Test Support"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-equation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-hash.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-comparison.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Coproduct",
            dependencies: [
                .product(name: "Equation", package: "swift-equation"),
                .product(name: "Hash", package: "swift-hash"),
                .product(name: "Comparison", package: "swift-comparison"),
            ],
            path: "Sources/Coproduct"
        ),
        
        .target(
            name: "Coproduct Foundation Integration",
            dependencies: [
                .target(name: "Coproduct"),
            ],
            path: "Sources/Coproduct Foundation Integration"
        ),
        .target(
            name: "Coproduct Test Support",
            dependencies: [
                .target(name: "Coproduct"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Coproduct Tests",
            dependencies: [
                .target(name: "Coproduct"),
                .target(name: "Coproduct Test Support"),
                .target(name: "Coproduct Foundation Integration"),
            ],
            path: "Tests/Coproduct Tests"
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
