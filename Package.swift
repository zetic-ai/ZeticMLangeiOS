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
            url: "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.4.2/ZeticMLange.xcframework.zip",
            checksum: "776d2e5d5d1c59ed3fc01e3c9eddf0cbc053bdbb1b69346508d347ee327f3fa1"
        )
    ]
)
