# NativeStudy：SwiftUI + SwiftData 双平台练习

一个可以运行、修改和测试的学习条目管理应用。核心功能：新增、编辑、取消草稿、删除、完成标记、搜索、会话偏好、本地持久化、明确保存错误，以及与视图生命周期关联的异步加载示范。

## 运行

要求完整 Xcode 16 或更新版本（提供 Swift 6 编译器和平台 SDK），已完成首次启动安装组件。项目设置 Swift 6 语言模式，最低部署版本 iOS 17 / macOS 14。本次实际构建环境见下方验证记录。无需第三方依赖、网络服务或开发者账户。

1. 打开已附带的 `NativeStudy.xcodeproj`。**不需要安装 XcodeGen**。
2. macOS：选 `NativeStudy-macOS` scheme → `My Mac` → ⌘R。
3. iOS：选 `NativeStudy-iOS` scheme → 一个已安装的 iPhone/iPad **模拟器** → ⌘R。若没有模拟器 runtime，在 Xcode Settings → Components 中安装。
4. 测试：选 `NativeStudy-macOS` → ⌘U。测试使用 Swift Testing，数据库测试分别创建独立内存容器。
5. 项目默认关闭代码签名，适用于本机与模拟器学习。若要在**真实 iPhone/iPad**运行，需要自行选择签名 Team、有效 bundle identifier，并对设备构建启用签名；本次未做真机验收。

命令在工作区根目录执行：

```sh
open examples/NativeStudy/NativeStudy.xcodeproj

xcodebuild -project examples/NativeStudy/NativeStudy.xcodeproj \
  -scheme NativeStudy-macOS -destination 'platform=macOS' \
  -derivedDataPath /tmp/swift-learning-native-study \
  test CODE_SIGNING_ALLOWED=NO

xcodebuild -project examples/NativeStudy/NativeStudy.xcodeproj \
  -scheme NativeStudy-iOS -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/swift-learning-native-study-ios \
  build CODE_SIGNING_ALLOWED=NO
```

最后一条是模拟器平台构建，不会启动模拟器或验证触摸交互。

## 先做一次完整操作

1. 点击工具栏 `+`，创建标题 `SwiftUI 数据流`，填写笔记并保存。
2. 选择条目，编辑标题后取消，确认原数据保留。
3. 重新编辑并保存，切换完成状态，搜索标题。
4. 打开设置：macOS 菜单 Settings（⌘,），iOS 工具栏齿轮。关闭 `Show completed items` 后已完成条目应隐藏。
5. 打开 `Simulate resource failure`，详情中的离线资源加载应显示错误；关闭开关后恢复成功。加载过程只是可取消的固定延迟 fixture，点击阅读链接才访问 Apple 文档。
6. 详情 → Workshops → Layout workshop：比较修饰器顺序。Native bridge workshop：两个输入控件编辑同一状态，练习 SwiftUI 与 UIKit/AppKit 双向桥接。
7. macOS 用 ⇧⌘N 新建条目。关闭应用后重开，学习条目仍保留；偏好是**当前会话状态**，重启恢复默认。
8. 删除前先搜索，使列表只剩一项，确认删除的是过滤结果对应的记录。

## 文件地图与课程

| 文件 | 责任 | 对应课 |
|---|---|---|
| `Sources/NativeStudyApp.swift` | App/Scene、容器初始化、依赖注入、Settings、菜单命令 | 25、28、38 |
| `Sources/StudyPreferences.swift` | `@Observable @MainActor` 会话偏好 | 28 |
| `Sources/StudyItem.swift` | `@Model`、值类型草稿、验证、显式保存/回滚 | 27、31、33 |
| `Sources/StudyListView.swift` | `@Query`、身份、搜索、删除映射、分栏、内存 Preview | 29、30、33 |
| `Sources/StudyEditorView.swift` | State/Binding、焦点、提交/取消、错误反馈 | 27、31 |
| `Sources/StudyDetailView.swift` | 类型导航、`.task(id:)`、动画、布局实验 | 26、30、32、34 |
| `Sources/ResourceLoader.swift` | 可取消离线 fixture、加载状态机、过期结果保护 | 32 |
| `Sources/NativeBridgeWorkshopView.swift` | `UIViewRepresentable` / `NSViewRepresentable`、Coordinator、组合输入保护 | 39 |
| `Resources/Localizable.xcstrings` | 英文与简体中文 UI 文案 | 34 |
| `Tests/NativeStudyTests.swift` | 草稿/数据库行为、资源成功/失败/取消/时序测试 | 33、36 |
| `project.yml` | 可选的 XcodeGen 工程源，供维护者重生成 `.xcodeproj` | 41 |

学习时优先打开上方源文件，注释解释所有权、取消和提交边界；不要把整个项目一次背下来。

## 数据与隔离边界

- 学习记录保存在本机 SwiftData 默认存储，**未接入 CloudKit**。不声明数据会自动跨设备同步。
- 所有 UI 模型和写入入口使用显式 `@MainActor`。SwiftData 对象只在其 context 所属隔离域使用，异步服务返回 Sendable 值。
- 编辑时只修改 `StudyDraft`，提交时才改模型，确保取消不会污染持久对象。
- 此教学项目在一个主 context 中同步提交，每次失败 rollback 后把错误抛给 UI；所有编辑均留在草稿中。更复杂的多个并行事务应设计独立 context/repository，不能直接照搬“回滚全部未提交改动”。
- 模型初始化和保存失败会展示真实错误，不会吞掉错误或擅自删库。磁盘不足等真实保存故障尚未注入验收。
- 偏好不使用 UserDefaults；`@Observable` 只负责可观察性，不是持久化机制。
- `ResourceService` 是确定性离线 fixture，**不代表 HTTP、真实服务器和网络状态已测试**。
- Preview 与单元测试使用内存存储，避免污染运行中的学习记录。

## 无障碍与平台验收练习

新增 UI 使用系统控件、语义字体、可访问标签和文字状态，不只依赖颜色。Scheme → Run → Options 可切换 App Language，分别查看英文与简体中文。请自行完成大字号、VoiceOver、Reduce Motion、键盘导航、中文组合输入、iPhone 窄屏、iPad 分栏和保存失败路径验收；编译或 Preview 通过不能替代这些检查。

## 维护工程

普通学习不需要重新生成工程。若修改 target 或文件组织并已安装 XcodeGen：

```sh
xcodegen generate --spec examples/NativeStudy/project.yml
```

共享 schemes 已包含在工程中。不要提交 DerivedData、xcuserstate 或本机签名设置。

## 验证记录

2026-09-22，Xcode 27.0 / Swift 6 语言模式：

- macOS app 编译通过。
- iOS Simulator 平台 unsigned build 通过。
- macOS Swift Testing：10 个测试全部通过（2 个 suite），覆盖标题空白/字符边界、增改完成删除提交、取消草稿、编辑期间记录被删除、加载成功/错误/取消、逆序返回和启动前取消。
- macOS 原生 UI 冒烟验证：创建并保存、修改后取消保留原值、切换完成状态后列表同步、打开原生桥接实验室、AppKit 输入同步到 SwiftUI 均通过。
- 运行系统环境输出了 AppIntents metadata skipped 等工具消息；本项目没有 AppIntents 功能。测试结果以 xcodebuild 退出状态和具体测试断言为准。
- 真机、VoiceOver、运行最低部署系统、真实存储失败和真实网络行为不在已验证范围。
