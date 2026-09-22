// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftFoundations",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "FoundationCore", targets: ["FoundationCore"]),
        .executable(name: "foundation-lab", targets: ["FoundationLab"]),
    ],
    targets: [
        .target(name: "FoundationCore"),
        .executableTarget(name: "FoundationLab", dependencies: ["FoundationCore"]),
        .testTarget(name: "FoundationCoreTests", dependencies: ["FoundationCore"]),
    ],
    // 编译器版本与语言模式不同；用较新编译器也可显式选择 Swift 6 模式。
    swiftLanguageModes: [.v6]
)
