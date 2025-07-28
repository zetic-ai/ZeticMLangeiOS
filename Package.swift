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
            url: "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.3.0/ZeticMLange.xcframework.zip",
            checksum: "79f1516fbf208e315fd30227c83fd022ae308ca20160f5de84eb16d6be1a3761"
        )
    ]
)
