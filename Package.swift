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
            url: "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.3.2/ZeticMLange.xcframework.zip",
            checksum: "8262fd9735bcc781fbb7d7abe1d5d277491a351e12a60ee3abd314e4ec743870"
        )
    ]
)
