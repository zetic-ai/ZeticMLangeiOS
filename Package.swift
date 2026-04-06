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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.5.13/ZeticMLange.xcframework.zip",
      checksum: "ed00278c9180062df0dd60676946a554e41d8add44de404b1d1463cbe59b383c"
    )
  ]
)
