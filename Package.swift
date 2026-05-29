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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.8.0/ZeticMLange.xcframework.zip",
      checksum: "cddd81a9cbbfcc47f3c9747f5659c2b7a4c711fa57e3328808dcd8093da30bb3"
    )
  ]
)
