// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "ZeticMLangeiOS",
  platforms: [
    .iOS(.v13)
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
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.5.0/ZeticMLange.xcframework.zip",
      checksum: "839c427c0f10059ba633eac2cc8b6c7de258e378fb5b715bc35019225582830b"
    )
  ]
)
