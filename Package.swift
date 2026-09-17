// swift-tools-version: 6.4

import CompilerPluginSupport
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
        .library(name: "Coproduct Macro Core", targets: ["Coproduct Macro Core"]),
        .library(name: "Eliminator Macro", targets: ["Eliminator Macro"]),
        .library(name: "Eliminator Macro Core", targets: ["Eliminator Macro Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "603.0.2"..<"604.0.0"),
    ],
    targets: [
        .target(
            name: "Coproduct",
            dependencies: [],
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
        .target(
            name: "Coproduct Macro Core",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "Coproduct Macro Tests",
            dependencies: [
                "Coproduct Macro Core",
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "Eliminator Macro Core",
            dependencies: [
                "Coproduct Macro Core",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]
        ),
        .macro(
            name: "Eliminator Macro Plugin",
            dependencies: [
                "Eliminator Macro Core",
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "Eliminator Macro",
            dependencies: ["Eliminator Macro Plugin"]
        ),
        .testTarget(
            name: "Eliminator Macro Tests",
            dependencies: [
                "Eliminator Macro",
                "Eliminator Macro Plugin",
                .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosGenericTestSupport", package: "swift-syntax"),
            ],
            resources: [.copy("Fixtures")]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("MoveOnlyTuples"),
    ]
}
