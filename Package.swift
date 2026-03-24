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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.5.11/ZeticMLange.xcframework.zip",
      checksum: "557e9e2bb80a4cf1f86fefc3ea632c244e1bddd72833c0bfe6f7b2dd7c7bdb12"
    )
  ]
)
