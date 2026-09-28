// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SprygKit",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "SprygKit", targets: ["SprygKit"]),
    ],
    targets: [
        .target(
            name: "SprygKit",
            resources: [.copy("Fixtures")]
        ),
        .testTarget(
            name: "SprygKitTests",
            dependencies: ["SprygKit"]
        ),
    ]
)
