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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.5.0/ZeticMLange.xcframework.zip",
      checksum: "ca85b629e56b36943c4eadfc40951e44ce5e9e4165ec2ddf286a9c8ef225933f"
    )
  ]
)
