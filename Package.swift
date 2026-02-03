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
    )
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
      url:
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.5.0/ZeticMLange.xcframework.zip",
      checksum: "3f0c3fa8750ecf416ba619e268d03778029a6a404eca8b6e04fe5b58f70c5ce2"
    ),
  ]
)
