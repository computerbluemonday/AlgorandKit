// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AlgorandKit",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(
      name: "AlgorandKit",
      targets: ["AlgorandKit"])
  ],
  dependencies: [
    // .package(url: /* package url */, from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "AlgorandKit",
      dependencies: [],
      resources: [
        .copy("Resources/AlgorandKit.xcassets")
      ]),
    .testTarget(
      name: "AlgorandKitTests",
      dependencies: ["AlgorandKit"])
  ]
)


