# Swift 与 Apple Native Resources

官方资料核对日期：2026-09-22。正文采用原创例子与解释；版本、语言规则和 API 语义回到一手资料核查。Swift Book 的 JavaScript 页面必要时核对 swiftlang/swift-book 官方源码；Apple 文档必要时读取同页 Markdown/DocC 数据。

## Knowledge

### Swift 基础

- [Swift.org：Build a Command-line Tool](https://www.swift.org/getting-started/cli-swiftpm/)
  用于：1 建立可重复运行的 Swift 开发环境；14 里程碑：交付一个有行为测试的学习计划核心。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：The Basics](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/thebasics/)
  用于：2 用类型表达数据：let、var 与数值转换；5 把“可能没有值”变成必须处理的分支。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Strings and Characters](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/stringsandcharacters/)
  用于：3 按用户看到的字符处理 Unicode 文本。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Collection Types](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/collectiontypes/)
  用于：4 选择集合并用控制流统计主题。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Control Flow](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/controlflow/)
  用于：4 选择集合并用控制流统计主题；5 把“可能没有值”变成必须处理的分支；9 用枚举排除不可能的状态。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Functions](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/functions/)
  用于：6 写出调用点清晰的函数。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Swift.org：API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
  用于：6 写出调用点清晰的函数；14 里程碑：交付一个有行为测试的学习计划核心。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Closures](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures/)
  用于：7 用闭包组成可读的数据转换。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Structures and Classes](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/classesandstructures/)
  用于：8 用结构体保护业务状态的边界；12 看见引用共享，打断闭包保留环。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Properties](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties/)
  用于：8 用结构体保护业务状态的边界。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Enumerations](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/enumerations/)
  用于：9 用枚举排除不可能的状态。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Protocols](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/)
  用于：10 用协议表达能力，用扩展共享实现。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Generics](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/)
  用于：11 分清泛型、some 与 any 的类型选择权。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Opaque and Boxed Protocol Types](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/opaquetypes/)
  用于：11 分清泛型、some 与 any 的类型选择权。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Automatic Reference Counting](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/)
  用于：12 看见引用共享，打断闭包保留环。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Error Handling](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/errorhandling/)
  用于：13 把 JSON 变成可信模型，并保留失败原因。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Apple：Encoding and Decoding Custom Types](https://developer.apple.com/documentation/foundation/encoding-and-decoding-custom-types)
  用于：13 把 JSON 变成可信模型，并保留失败原因。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Swift Testing：官方 README 与快速示例](https://github.com/swiftlang/swift-testing/blob/main/README.md)
  用于：14 里程碑：交付一个有行为测试的学习计划核心。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [The Swift Programming Language：Access Control](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/accesscontrol/)
  用于：14 里程碑：交付一个有行为测试的学习计划核心。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。

### Swift 6 与并发

- [SE-0296：Async/await](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0296-async-await.md)
  用于：15 async / await：挂起、恢复与错误。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [SE-0338：非 actor async 执行语义](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0338-clarify-execution-non-actor-async.md)
  用于：15 async / await：挂起、恢复与错误。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [SE-0317：async let](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0317-async-let.md)
  用于：16 async let：固定数量的结构化子任务。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [SE-0304：结构化并发](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0304-structured-concurrency.md)
  用于：17 TaskGroup：动态并发、结果顺序与失败；18 Task 生命周期与合作式取消。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [SE-0306：Actor 与重入](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0306-actors.md)
  用于：19 Actor：隔离状态与 await 后的不变量。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [SE-0302：Sendable 与 @Sendable](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0302-concurrent-value-and-concurrent-closures.md)
  用于：20 Sendable、@Sendable 与 sending。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [SE-0430：sending（Swift 6.0）](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0430-transferring-parameters-and-results.md)
  用于：20 Sendable、@Sendable 与 sending。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [SE-0316：Global Actors](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0316-global-actors.md)
  用于：21 MainActor：UI 状态、重入与默认隔离。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [SE-0466：默认 actor 隔离（Swift 6.2）](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0466-control-default-actor-isolation.md)
  用于：21 MainActor：UI 状态、重入与默认隔离；24 Swift 6 迁移与并发里程碑。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Apple：URLSession.data(for:delegate:)](https://developer.apple.com/documentation/foundation/urlsession/data(for:delegate:))
  用于：22 URLSession：HTTP 校验与可测试的数据边界。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Apple：HTTPURLResponse.statusCode](https://developer.apple.com/documentation/foundation/httpurlresponse/statuscode)
  用于：22 URLSession：HTTP 校验与可测试的数据边界。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Apple：JSONDecoder.decode(_:from:)](https://developer.apple.com/documentation/foundation/jsondecoder/decode(_:from:))
  用于：22 URLSession：HTTP 校验与可测试的数据边界。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [SE-0314：AsyncStream](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0314-async-stream.md)
  用于：23 AsyncSequence 与回调桥接：结束也属于契约。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [SE-0300：Continuation](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0300-continuation.md)
  用于：23 AsyncSequence 与回调桥接：结束也属于契约。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Swift 6 迁移：渐进采用](https://www.swift.org/migration/documentation/swift-6-concurrency-migration-guide/incrementaladoption/)
  用于：24 Swift 6 迁移与并发里程碑。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Swift 6 迁移：启用数据竞争检查](https://www.swift.org/migration/documentation/swift-6-concurrency-migration-guide/enabledataracesafety/)
  用于：24 Swift 6 迁移与并发里程碑。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [SE-0461：调用者隔离与 upcoming flag（Swift 6.2）](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md)
  用于：24 Swift 6 迁移与并发里程碑。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。

### SwiftUI

- [App](https://developer.apple.com/documentation/swiftui/app)
  用于：25 从 App 到 View：声明式界面的边界。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [View](https://developer.apple.com/documentation/swiftui/view)
  用于：25 从 App 到 View：声明式界面的边界；26 布局与修饰器：理解包裹顺序。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Laying out a simple view](https://developer.apple.com/documentation/swiftui/laying-out-a-simple-view)
  用于：26 布局与修饰器：理解包裹顺序。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [State](https://developer.apple.com/documentation/swiftui/state)
  用于：27 State 与 Binding：找到唯一数据源；29 身份与列表：状态为什么会保留或重置。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Binding](https://developer.apple.com/documentation/swiftui/binding)
  用于：27 State 与 Binding：找到唯一数据源；31 表单：验证、草稿与键盘焦点。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Managing model data in your app](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app)
  用于：28 Observation：共享模型、所有权与隔离。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [ForEach](https://developer.apple.com/documentation/swiftui/foreach)
  用于：29 身份与列表：状态为什么会保留或重置。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack)
  用于：30 导航：以数据描述目标和路径。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [NavigationSplitView](https://developer.apple.com/documentation/swiftui/navigationsplitview)
  用于：30 导航：以数据描述目标和路径。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [FocusState](https://developer.apple.com/documentation/swiftui/focusstate)
  用于：31 表单：验证、草稿与键盘焦点。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [View task with identity](https://developer.apple.com/documentation/swiftui/view/task(id:name:priority:file:line:_:))
  用于：32 视图任务：加载、取消与过期结果。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Task cancellation](https://developer.apple.com/documentation/swift/task)
  用于：32 视图任务：加载、取消与过期结果。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Preserving model data across launches](https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches)
  用于：33 SwiftData：模型、查询和保存失败。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [ModelContext.save](https://developer.apple.com/documentation/swiftdata/modelcontext/save())
  用于：33 SwiftData：模型、查询和保存失败。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [animation(_:value:)](https://developer.apple.com/documentation/swiftui/view/animation(_:value:))
  用于：34 动画、无障碍与本地化。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Reduce Motion](https://developer.apple.com/documentation/swiftui/environmentvalues/accessibilityreducemotion)
  用于：34 动画、无障碍与本地化。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Accessibility element children](https://developer.apple.com/documentation/swiftui/view/accessibilityelement(children:))
  用于：34 动画、无障碍与本地化。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [LocalizedStringKey](https://developer.apple.com/documentation/swiftui/localizedstringkey)
  用于：34 动画、无障碍与本地化。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。

### 原生工程实践

- [Managing model data in your app](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app)
  用于：35 让业务规则离开 View。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [ModelContext](https://developer.apple.com/documentation/swiftdata/modelcontext)
  用于：35 让业务规则离开 View。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [XCTest and XCUIAutomation](https://developer.apple.com/documentation/xctest)
  用于：36 用测试描述用户能依赖的行为。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Adding tests to your Xcode project](https://developer.apple.com/documentation/xcode/adding-tests-to-your-xcode-project)
  用于：36 用测试描述用户能依赖的行为。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Performance and metrics](https://developer.apple.com/documentation/xcode/performance-and-metrics)
  用于：37 用 Xcode 解释一次卡顿与一次对象泄漏。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Improving your app’s performance](https://developer.apple.com/documentation/xcode/improving-your-app-s-performance)
  用于：37 用 Xcode 解释一次卡顿与一次对象泄漏。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Bring multiple windows to your SwiftUI app](https://developer.apple.com/videos/play/wwdc2022/10061/)
  用于：38 让 Mac 应用像一个 Mac 应用。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [SwiftUI apps and scenes](https://developer.apple.com/documentation/technologyoverviews/swiftui)
  用于：38 让 Mac 应用像一个 Mac 应用。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [UIViewRepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable)
  用于：39 把 UIKit / AppKit 控件接入 SwiftUI。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [NSViewRepresentable](https://developer.apple.com/documentation/swiftui/nsviewrepresentable)
  用于：39 把 UIKit / AppKit 控件接入 SwiftUI。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [fileImporter](https://developer.apple.com/documentation/swiftui/view/fileimporter(ispresented:allowedcontenttypes:oncompletion:))
  用于：40 把文件、偏好和敏感数据放在正确位置。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Keychain services](https://developer.apple.com/documentation/security/keychain-services)
  用于：40 把文件、偏好和敏感数据放在正确位置。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Privacy manifest files](https://developer.apple.com/documentation/bundleresources/privacy-manifest-files)
  用于：40 把文件、偏好和敏感数据放在正确位置。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)
  用于：41 从本地构建走到可交付版本。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Notarizing macOS software before distribution](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution)
  用于：41 从本地构建走到可交付版本。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Testing a release build](https://developer.apple.com/documentation/xcode/testing-a-release-build)
  用于：41 从本地构建走到可交付版本。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [TSPL — Macros](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/)
  用于：42 读懂宏、所有权与版本边界。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [SE-0390 Noncopyable structs and enums](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0390-noncopyable-structs-and-enums.md)
  用于：42 读懂宏、所有权与版本边界。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [ScenePhase](https://developer.apple.com/documentation/swiftui/scenephase)
  用于：43 处理生命周期、深链接与后台边界。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [onOpenURL](https://developer.apple.com/documentation/swiftui/view/onopenurl(perform:))
  用于：43 处理生命周期、深链接与后台边界。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Choosing Background Strategies for Your App](https://developer.apple.com/documentation/backgroundtasks/choosing-background-strategies-for-your-app)
  用于：43 处理生命周期、深链接与后台边界。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Swift Forums](https://forums.swift.org/)
  用于：44 毕业项目：独立完成一个可解释的原生功能。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Apple Developer Forums](https://developer.apple.com/forums/)
  用于：44 毕业项目：独立完成一个可解释的原生功能。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
  用于：44 毕业项目：独立完成一个可解释的原生功能。与该课示例对照阅读，先看相关段落，不要求一次读完整份文档。

- [SE-0413 Typed throws](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0413-typed-throws.md)
  用于：第13课 Swift6 类型化错误与穷尽处理；注意提案已实现部分与尚未实现的推断扩展并不相同。

## Wisdom (Communities)

- [Swift Forums](https://forums.swift.org/)
  Swift 官方社区；用于语言规则、并发隔离、提案与最小编译问题讨论。提问附完整最小示例、语言模式、工具链与实际诊断。
- [Apple Developer Forums](https://developer.apple.com/forums/)
  Apple 平台 API 的实践讨论；用于系统版本行为、SwiftUI、持久化与发布问题。先搜对应 tag，说明真机/模拟器与系统版本。
- [WWDC 视频](https://developer.apple.com/videos/)
  按课程主题找官方工程师示例与设计动机；视频年份、API 系统可用性和当前文档一起核对。

用户未说明社区参与偏好；社区评审为可选，不代替当前课程指导，不自动替用户发帖。

## Gaps

- 当前机器实际使用 Swift6.4/Xcode27；Swift6.0原始编译器和iOS17/macOS14最低系统未逐一实测。
- 主线覆盖开发与交付方法，真实签名、公证、TestFlight、App Store 提交仍需用户后续实践。
- WidgetKit/App Intents、CloudKit、APNs、StoreKit、Combine/Core Data旧项目维护等列为后续专项。当前44课不是每个Apple框架的完整百科。
- 官方文档会更新；发布要求与新语言特性在实际使用时再次确认，不把课程核对日当作永久保证。
