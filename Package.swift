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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.12.0/ZeticMLange.xcframework.zip",
      checksum: "d9da5cd883ea7e79dfc3e2e42266ab8945056c6722097e47d198c50566d02dbf"
    )
  ]
)
