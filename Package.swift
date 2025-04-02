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
            url: "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.1.0/ZeticMLange.xcframework.zip",
            checksum: "5784bf1be7435772acdcecfbcc432b939ae84812c4bd2da353758c56f17642c4"
        )
    ]
)