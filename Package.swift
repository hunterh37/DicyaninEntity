// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DicyaninEntity",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "DicyaninEntity",
            targets: ["DicyaninEntity"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DicyaninEntity",
            dependencies: [])
    ]
) 