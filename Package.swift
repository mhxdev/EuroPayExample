// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "EUPayExample",
    platforms: [
        .iOS(.v16),
    ],
    dependencies: [
        .package(url: "https://github.com/mhxdev/EUPayKit", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "EUPayExample",
            dependencies: [
                .product(name: "EUPayKit", package: "EUPayKit"),
            ],
            path: "EUPayExample"
        ),
    ]
)
