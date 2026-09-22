# Swift 基础实验室

这是第 1–14 课的完整参考实现。用 SwiftPM 构建、Swift Testing 验证，无第三方依赖，无网络请求，不读取或修改用户文件。所有命令从 `swift-learning` 工作区根目录执行。

```sh
swift --version
swift build --package-path examples/SwiftFoundations
swift run --package-path examples/SwiftFoundations foundation-lab 1
swift run --package-path examples/SwiftFoundations foundation-lab all
swift test --package-path examples/SwiftFoundations
```

把最后的 `1` 换成 `2` 至 `14` 即可选择单课演示。参数不合法时程序打印用法并以错误退出。在 Xcode 中打开此目录的 `Package.swift`，选择 `foundation-lab` scheme，也可以设置命令行参数并运行。

包要求 Swift 工具链 6.0 或更新，显式采用 Swift 6 语言模式，声明 macOS 14 最低系统。`swift-tools-version`、`swiftLanguageModes`、编译器实际版本、系统 SDK 和 deployment target 是不同概念。这里的语言实验是 macOS 命令行程序，不是 iOS App；原生 App 项目在后续模块。

## 按阶段阅读

| 课 | 演示 | 重点文件 | 看到的结果 |
|---|---|---|---|
| 1 | `foundation-lab 1` | `Package.swift`、`FoundationLab.swift` | 库到可执行程序的依赖方向 |
| 2 | `foundation-lab 2` | `Basics.swift` | `2/5 = 0.4` |
| 3 | `foundation-lab 3` | `Basics.swift` | Character 8、UTF16 14；组合 emoji 完整 |
| 4 | `foundation-lab 4` | `Basics.swift` | Swift 2 次、UI 1 次 |
| 5 | `foundation-lab 5` | `Basics.swift` | 25 合法；0、abc、nil 无效 |
| 6 | `foundation-lab 6` | `Basics.swift` | 参数标签、默认值、原地累计到 35 |
| 7 | `foundation-lab 7` | `Basics.swift` | 清理空白、忽略大小写、排序 |
| 8 | `foundation-lab 8` | `Models.swift` | 原值未完成，副本完成 |
| 9 | `foundation-lab 9` | `Models.swift` | 关联值与穷尽模式匹配 |
| 10 | `foundation-lab 10` | `Models.swift` | 协议扩展提供摘要 |
| 11 | `foundation-lab 11` | `Models.swift` | 保序去重、some 返回、any 混装 |
| 12 | `foundation-lab 12` | `Ownership.swift` | 身份共享、弱捕获后可释放 |
| 13 | `foundation-lab 13` | `Persistence.swift` | JSON 往返、业务错误与清理 |
| 14 | `foundation-lab 14` | `StudyPlan.swift` | 2 项、60 分钟、完成 1 项 |

库文件位于 `Sources/FoundationCore/`，演示入口位于 `Sources/FoundationLab/`，测试位于 `Tests/FoundationCoreTests/`。同一包中不同 target 是不同模块，所以演示与测试需要 `import FoundationCore`。公开 API 的范围是有意设计的，不需要为了测试访问私有实现而暴露更多成员。

先读当课 HTML，预测输出，再运行对应编号；之后隐藏一个目标函数体、自己重写并运行测试。包中同时存在后续章节的完整代码是为了便于一次获得完整课程，不要求第一天读懂全部实现。`Codable` 和 `Sendable` 在 `StudySession` 中提前出现，会分别在后续章节解释。

## 行为验证

```sh
swift test --package-path examples/SwiftFoundations --filter unicodePreview
swift test --package-path examples/SwiftFoundations --filter ownership
swift test --package-path examples/SwiftFoundations --filter planMilestone
```

测试保护完成比例的小数、组合 emoji 截取、输入边界、频次与保序去重、搜索、值语义、协议调用、ARC 释放、JSON 往返与业务校验、`defer` 的错误路径、计划操作幂等和越界不变性。断言前先执行 `mutating` 操作，避免将带副作用的调用放在宏表达式中。

2026-09-22 在本机 Apple Swift 6.4（arm64，Xcode 提供的工具链）实际执行：

- `swift test`：13 个 Swift Testing 测试通过，其中“分钟输入校验”包含 5 个参数化案例。
- `foundation-lab all`：14 个演示运行完成，退出码 0。
- 测试日志中的 XCTest “Executed 0 tests”不是最终结果；继续查看 Swift Testing 的“13 tests passed”。

这证明当前工具链上的构建与行为，不等于已在 macOS 14 实机或原始 Swift 6.0 编译器上运行。包选择的是 Swift 6 语言模式，不使用 Swift 6.2+ 才引入的语法。当前模型是教学核心：`decodePlan` 在外部 JSON 边界验证标题和分钟范围，直接初始化器则由调用者提供合法业务值；生产库可以进一步收紧构造边界。

## 官方资料

课程正文提供每课对应的准确入口。编写时已阅读以下官方资料；Swift Book 网页需要 JavaScript 的地方，核对了 [Swift 官方源码仓库](https://github.com/swiftlang/swift-book/tree/main/TSPL.docc/LanguageGuide) 中相应章节。

- [The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/)：基础、字符串、集合、控制流、函数、闭包、结构体、属性、枚举、协议、泛型、不透明与存在类型、ARC、错误处理、访问控制。
- [SwiftPM 命令行入门](https://www.swift.org/getting-started/cli-swiftpm/)：包清单、target、可执行入口和运行。
- [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)：调用点清晰与命名约定。
- [Swift Testing 官方说明](https://github.com/swiftlang/swift-testing/blob/main/README.md)：测试宏、参数化、并行执行和工具链集成。
- [Apple：Encoding and Decoding Custom Types](https://developer.apple.com/documentation/foundation/encoding-and-decoding-custom-types)：Codable 合成、键映射和自定义解码；同时核对官方文档 JSON 内容。

阅读参考实现和通过测试都不自动代表掌握。学习证据应来自你独立完成的修改、对失败原因的解释，以及隔天不看答案仍能复现的能力。
