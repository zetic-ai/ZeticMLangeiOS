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
            url: "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.2.2/ZeticMLange.xcframework.zip",
            checksum: "4e7087704d4ce8382cb917ca4702c0d62f2eccc747d2ee9f6dbae9b4a6a46478"
        )
    ]
)
