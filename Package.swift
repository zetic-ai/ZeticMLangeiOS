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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.5.14/ZeticMLange.xcframework.zip",
      checksum: "3afb9ae1bb11c28ad159ca9af99b6cad3fe2f366372a75fbe973c140068584aa"
    )
  ]
)
