// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ZeticMLange",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ZeticMLange",
            targets: ["ZeticMLange"]),
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "ZeticMLange",
            path: "ZeticMLange.xcframework"
        )
    ]
)
