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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.5.2/ZeticMLange.xcframework.zip",
      checksum: "ffa4aae1f4f6b2a1fc8ca73c1592296f6fda4bc6807701daecd2e64c63049eaf"
    )
  ]
)
