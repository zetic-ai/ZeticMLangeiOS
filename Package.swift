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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.7.0-beta.1/ZeticMLange.xcframework.zip",
      checksum: "00d08f1dd705c779082a3cd17e27ae02753b33cc974da9b955f15b0256e5662f"
    )
  ]
)
