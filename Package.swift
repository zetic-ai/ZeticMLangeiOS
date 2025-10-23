// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ZeticMLangeiOS",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ZeticMLange",
            targets: ["ZeticMLangeWrapper"]
        ),
    ],
    targets: [
        .target(
            name: "ZeticMLangeWrapper",
            dependencies: [
                .target(name: "ZeticMLangeBinary")
            ],
            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        ),
        .binaryTarget(
            name: "ZeticMLangeBinary",
            url: "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.4.5/ZeticMLange.xcframework.zip",
            checksum: "6099f6bdd9764e6e924ef75cfae6a7dff20f7dc1dd8935c6104c3b0e9a3af614"
        )
    ]
)
