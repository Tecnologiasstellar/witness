// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "WitnessCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "WitnessCore", targets: ["WitnessCore"])
    ],
    targets: [
        .target(
            name: "WitnessCore",
            resources: [
                .copy("Resources/catalog"),
                .copy("Resources/fieldseason")
            ]
        ),
        .testTarget(
            name: "WitnessCoreTests",
            dependencies: ["WitnessCore"]
        )
    ]
)
