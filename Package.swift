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
            targets: ["ZeticMLangeWrapper"]
        ),
    ],
    targets: [
        .target(
            name: "ZeticMLangeWrapper",
            dependencies: [
                .target(name: "ZeticMLangeBinary")
            ],
            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        ),
        .binaryTarget(
            name: "ZeticMLangeBinary",
            url: "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.4.4/ZeticMLange.xcframework.zip",
            checksum: "78ec3b5a2f1b93cb05c52bc1c60759563fb1a53693dd3dc759151123dd30c6ee"
        )
    ]
)
