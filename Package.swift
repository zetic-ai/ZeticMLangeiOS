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
            url: "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.2.0/ZeticMLange.xcframework.zip",
            checksum: "8489a7a93ba9925c9b255eaf3e1e501d53dedc8318e07173b3e040032b1dfb2e"
        )
    ]
)
