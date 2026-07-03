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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.9.0/ZeticMLange.xcframework.zip",
      checksum: "c9a03f9854adbbe65320fa29d6460a0a645b1d911e6219e662c2f679d8f04134"
    )
  ]
)
