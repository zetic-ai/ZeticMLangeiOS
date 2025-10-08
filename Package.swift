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
            url: "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.4.0/ZeticMLange.xcframework.zip",
            checksum: "9475ab3fe2cb3aa57d2dc1908af1b0301d755a17687205fc88bf4cda6e15bab6"
        )
    ]
)
