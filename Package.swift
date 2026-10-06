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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.11.0/ZeticMLange.xcframework.zip",
      checksum: "e0c1f138d17d767d5adeb6da114f8f381b2c7568ecc5cc79c8393d82aafd7065"
    )
  ]
)
