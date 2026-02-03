// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "ZeticMLangeiOS",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "ZeticMLange",
      targets: ["ZeticMLange"]
    )
  ],
  targets: [
    .target(
      name: "ZeticMLangeWrapper",
      dependencies: [
        .target(name: "ZeticMLange")
      ],
      linkerSettings: [
        .linkedFramework("Accelerate")
      ]
    ),
    .binaryTarget(
      name: "ZeticMLange",
      url:
        "https://github.com/zetic-ai/ZeticMLangeiOS/releases/download/1.5.0/ZeticMLange.xcframework.zip",
      checksum: "bbb4fc45f2bade95723f531823fc1c92e9d3fa29fa9e26dfd775cef9c10ae8b1"
    ),
  ]
)
