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
            targets: ["ZeticMLange"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "ZeticMLange",
            url: "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.2.1/ZeticMLange.xcframework.zip",
            checksum: "03da2560a124cd9dfc6aab72de4e71bd8f75d642ce4f0051c9e5f294fe3d5714"
        )
    ]
)
