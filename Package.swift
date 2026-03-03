// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "EuroPayExample",
    platforms: [
        .iOS(.v16),
    ],
    dependencies: [
        .package(url: "https://github.com/mhxdev/EuroPayKit", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "EuroPayExample",
            dependencies: [
                .product(name: "EuroPayKit", package: "EuroPayKit"),
            ],
            path: "EuroPayExample"
        ),
    ]
)
