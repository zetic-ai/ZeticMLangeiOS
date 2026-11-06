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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.13.0/ZeticMLange.xcframework.zip",
      checksum: "cc88b96f758ed04a2ce16d3a88c4f5e17ff1f125ab389ae5a77c8a568a83c3e6"
    )
  ]
)
