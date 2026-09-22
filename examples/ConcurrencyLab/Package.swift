// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ConcurrencyLab",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "ConcurrencyKit", targets: ["ConcurrencyKit"]),
        .executable(name: "ConcurrencyDemo", targets: ["ConcurrencyDemo"])
    ],
    targets: [
        .target(name: "ConcurrencyKit"),
        .executableTarget(name: "ConcurrencyDemo", dependencies: ["ConcurrencyKit"]),
        .testTarget(name: "ConcurrencyKitTests", dependencies: ["ConcurrencyKit"])
    ],
    // 编译器版本与语言模式不同；本课程明确选择 Swift 6 模式。
    swiftLanguageModes: [.v6]
)
