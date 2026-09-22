# 原生工程补充实验

此目录是第 13 / 40 / 42 / 43 课的独立练习片段，不是第 4 个完整应用。完整可运行应用为 `../NativeStudy`。

- `Ownership.swift`：根目录执行 `swift -swift-version 6 examples/PlatformRecipes/Ownership.swift`，输出两行导出状态。
- `ImportWorkshop.swift` / `LifecycleWorkshop.swift`：无 `@main` 的 SwiftUI View，可复制到 NativeStudy 的 Sources，再在 Xcode 添加文件到两个 app targets，以 Preview 或临时根视图运行。使用 Xcode 添加文件后无需 XcodeGen；若改用 project.yml 重新生成，也会自动收录 Sources。不要保留第二个 App 入口。
- 片段可先做 macOS 类型检查：`xcrun swiftc -swift-version 6 -typecheck examples/PlatformRecipes/ImportWorkshop.swift examples/PlatformRecipes/LifecycleWorkshop.swift`。
- 导入数据样例：`[{"title":"学习 Optional"},{"title":"解释 actor"}]`。此练习只验证解析，不会保存数据库。大文件不可在 MainActor 同步读取；在课程扩展中建立文件 I/O 服务、限制大小、支持取消后再集成。
- Lifecycle 的 `onOpenURL` 只处理系统已交付的 URL。运行自定义 scheme 还须在 target Info / URL Types 注册 `nativestudy`，冷启动后按 ID 查数据库并呈现页面。Universal Links 还需 Associated Domains 和网站关联文件。

这些片段不包含发布权限申请、真实后台任务或通知配置。依据第 40、43 课的验收步骤继续扩展。

## Swift 6 typed throws（第 13 课）

根目录执行：

```sh
swift -swift-version 6 examples/PlatformRecipes/TypedThrows.swift
```

程序接受 `25`，拒绝 `0` 和 `181`，输出三行。`validatedMinutes` 的错误范围固定为 `MinutesError`，因此 `catch` 中可以直接对它做穷尽 `switch`。这是一个本地同步校验；网络、JSON 和取消等错误来源混合时，普通 `throws` 往往更适合保留原始原因。

按源码注释，临时把 `throws(MinutesError)` 改成 `throws`，再次运行会在 `catch` 中看到类型诊断：`error` 已变成 `any Error`，不能直接当成 `MinutesError` 穷尽处理。恢复声明后重新运行。此练习不修改 SwiftFoundations 的业务 API，也不使用公网或用户文件。

依据 [SE-0413](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0413-typed-throws.md)，该语法自 Swift 6.0 起实现。本机编译与运行验证使用 Apple Swift 6.4；这不代表已经用原始 Swift 6.0 编译器实测。
