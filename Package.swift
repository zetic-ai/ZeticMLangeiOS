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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.5.7/ZeticMLange.xcframework.zip",
      checksum: "d908c0aefb1090dacac1e22b28e9eff91eb922a41f8b81010f4dc7d30085d22e"
    )
  ]
)
