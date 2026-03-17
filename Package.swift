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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.5.9/ZeticMLange.xcframework.zip",
      checksum: "304ee253c6697ea6276f32f84ec7364f2388eebb345a8d4f4e8f2d43cb6fa60b"
    )
  ]
)
