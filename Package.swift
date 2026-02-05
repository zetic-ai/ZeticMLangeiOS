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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.5.4/ZeticMLange.xcframework.zip",
      checksum: "f4df94e57f916daf853ea815d5d7dfeb255e6b6fe68913ab9e3f7cf1d1e2ceb3"
    )
  ]
)
