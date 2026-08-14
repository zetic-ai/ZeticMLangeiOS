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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.10.0/ZeticMLange.xcframework.zip",
      checksum: "8c95037689a1ac2f49ea962bff2724dce72099d8297e3bd216c94be8f1da5340"
    )
  ]
)
