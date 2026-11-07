// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "ZeticMLangeiOS",
  platforms: [
    .iOS("16.0")
  ],
  products: [
    .library(
      name: "ZeticMLange",
      targets: ["ZeticMLange"]
    )
  ],
  targets: [
    .binaryTarget(
      name: "ZeticMLange",
      url:
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.13.1/ZeticMLange.xcframework.zip",
      checksum: "17fbbda3eed330e74b3bec91f5ea3cb590d54758762e129c028a0eef7d985e4d"
    )
  ]
)
