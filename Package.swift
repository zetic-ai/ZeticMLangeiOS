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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.5.5/ZeticMLange.xcframework.zip",
      checksum: "cfca46d98d9e818340b5b7afbb7f2b063f39b7747222d728c15b4e6e55845b83"
    )
  ]
)
