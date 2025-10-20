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
    linkerSettings: [
        .linkedFramework("Accelerate")
    ],
    targets: [
        .binaryTarget(
            name: "ZeticMLange",
            url: "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.4.3/ZeticMLange.xcframework.zip",
            checksum: "2d65235393bb3e6b24bb4cd1110da725c3376e53c48c1e42e17191d5fa345aec"
        )
    ]
)
