# Swift / Native Lab 完整课程大纲

以 [MISSION.md](MISSION.md) 为目标。44 课已提供完整正文、练习、解答和官方资料，并非待生成占位。主线按编号学习；单课约 20–35 分钟，项目修改与复习另计。

## 学习路径与验收

| 阶段 | 内容 | 项目成果 | 阶段验收 |
|---|---|---|---|
| 1 / 01–14 | Swift 类型、控制流、建模、内存、测试 | SwiftFoundations | 独立完成一个有输入校验的 CLI，测试空值、非法值、序列化 |
| 2 / 15–24 | Swift 6、结构化并发、actor、网络 | ConcurrencyLab | 解释隔离边界，验证取消、HTTP 失败、乱序与共享状态 |
| 3 / 25–34 | SwiftUI、Observation、SwiftData | NativeStudy | 两个平台可运行增删改查，能解释每份状态的所有者 |
| 4 / 35–44 | 测试、调试、平台适配、交付 | NativeStudy 毕业扩展 | 依据 CAPSTONE.md 提供行为、失败路径和设备验收证据 |

## 逐课内容

| 课 | 主题 | 前置课 | 可观察成果 |
|---|---|---|---|
| 01 | [建立可重复运行的 Swift 开发环境](lessons/0001-toolchain-and-packages.html) | 无 | 从工作区运行第一个 SwiftPM 示例，并解释编译器、语言模式、SDK 与最低系统版本。 |
| 02 | [用类型表达数据：let、var 与数值转换](lessons/0002-bindings-and-types.html) | 1 | 编写不丢失小数的完成比例计算，并识别常量、变量和显式转换。 |
| 03 | [按用户看到的字符处理 Unicode 文本](lessons/0003-strings-and-unicode.html) | 2 | 生成不会截断组合 emoji 的标题预览。 |
| 04 | [选择集合并用控制流统计主题](lessons/0004-collections-and-control-flow.html) | 3 | 实现主题频次统计，并解释 Array、Set、Dictionary 的不同承诺。 |
| 05 | [把“可能没有值”变成必须处理的分支](lessons/0005-optionals-and-guard.html) | 4 | 将可空文本安全转换成 1 到 180 之间的学习分钟数。 |
| 06 | [写出调用点清晰的函数](lessons/0006-functions-and-labels.html) | 5 | 用参数标签、默认值与 inout 清楚表达输入和修改行为。 |
| 07 | [用闭包组成可读的数据转换](lessons/0007-closures-and-transformations.html) | 6 | 实现清理、筛选、排序的标题搜索流水线，并解释闭包捕获与逃逸。 |
| 08 | [用结构体保护业务状态的边界](lessons/0008-structs-and-value-semantics.html) | 7 | 创建一个可完成的学习任务，并用副本实验验证值语义。 |
| 09 | [用枚举排除不可能的状态](lessons/0009-enums-and-pattern-matching.html) | 8 | 用带关联值的枚举表达未开始、进行中和已完成，并穷尽处理。 |
| 10 | [用协议表达能力，用扩展共享实现](lessons/0010-protocols-and-extensions.html) | 9 | 让不同学习项目提供相同摘要接口，并理解协议要求与默认实现。 |
| 11 | [分清泛型、some 与 any 的类型选择权](lessons/0011-generics-some-and-any.html) | 10 | 实现保序去重，并为同构算法、隐藏返回类型和异构存储选择合适的类型形式。 |
| 12 | [看见引用共享，打断闭包保留环](lessons/0012-classes-arc-and-capture.html) | 11 | 解释 class 的引用身份，并验证弱捕获回调不会让拥有者泄漏。 |
| 13 | [把 JSON 变成可信模型，并保留失败原因](lessons/0013-errors-codable-and-cleanup.html) | 12 | 区分解码失败和业务校验失败，使用 throws 与 defer 组织成功和失败路径。 |
| 14 | [里程碑：交付一个有行为测试的学习计划核心](lessons/0014-testing-and-cli-milestone.html) | 13 | 完成可复用 StudyPlan 模块，并用 Swift Testing 验证边界和重复操作。 |
| 15 | [async / await：挂起、恢复与错误](lessons/0015-async-await.html) | 12, 14 | 编写并运行一个可抛错的异步函数，准确解释 await 的含义。 |
| 16 | [async let：固定数量的结构化子任务](lessons/0016-structured-async-let.html) | 15 | 用 async let 并发加载两份独立数据并组合成一个值。 |
| 17 | [TaskGroup：动态并发、结果顺序与失败](lessons/0017-task-groups.html) | 16 | 实现一个按输入顺序返回结果的异步映射。 |
| 18 | [Task 生命周期与合作式取消](lessons/0018-task-cancellation.html) | 17 | 持有 Task 句柄、发出取消信号，并验证工作主动退出。 |
| 19 | [Actor：隔离状态与 await 后的不变量](lessons/0019-actors-reentrancy.html) | 18 | 用 actor 实现并发预约，并证明挂起时不会超售。 |
| 20 | [Sendable、@Sendable 与 sending](lessons/0020-sendable-sending.html) | 19 | 用不可变快照跨隔离传值，并区分可共享类型与一次安全转移。 |
| 21 | [MainActor：UI 状态、重入与默认隔离](lessons/0021-main-actor.html) | 20 | 把界面状态显式隔离到 MainActor，并避免旧请求覆盖新结果。 |
| 22 | [URLSession：HTTP 校验与可测试的数据边界](lessons/0022-networking-fixtures.html) | 21 | 通过可注入 transport 加载、校验并解码一个网络模型。 |
| 23 | [AsyncSequence 与回调桥接：结束也属于契约](lessons/0023-async-sequence-bridging.html) | 22 | 消费一个可停止的事件流，并将单次回调桥接为 async。 |
| 24 | [Swift 6 迁移与并发里程碑](lessons/0024-swift-six-migration.html) | 23 | 区分工具链、语言模式与隔离开关，完成一次有证据的并发验收。 |
| 25 | [从 App 到 View：声明式界面的边界](lessons/0025-swiftui-app-scene-view.html) | 24 | 运行 NativeStudy，并用一个纯 View 描述学习条目的显示。 |
| 26 | [布局与修饰器：理解包裹顺序](lessons/0026-layout-and-modifiers.html) | 25 | 通过交换 padding 与 background，预测并验证布局结果。 |
| 27 | [State 与 Binding：找到唯一数据源](lessons/0027-state-and-binding.html) | 26 | 把编辑表单拆成父级草稿与子级笔记编辑器，并保留取消语义。 |
| 28 | [Observation：共享模型、所有权与隔离](lessons/0028-observation-and-ownership.html) | 27 | 用环境注入一份可观察偏好，并让设置页通过 Bindable 修改它。 |
| 29 | [身份与列表：状态为什么会保留或重置](lessons/0029-identity-lists-lifetime.html) | 28 | 用稳定 ID 列表，并在筛选状态下删除正确条目。 |
| 30 | [导航：以数据描述目标和路径](lessons/0030-typed-navigation.html) | 29 | 在详情中增加一个有类型的练习目标，并验证分栏与窄屏返回行为。 |
| 31 | [表单：验证、草稿与键盘焦点](lessons/0031-forms-validation-focus.html) | 30 | 实现“合法才保存、失败保留草稿、取消不污染模型”的编辑体验。 |
| 32 | [视图任务：加载、取消与过期结果](lessons/0032-view-tasks-and-cancellation.html) | 31 | 用 task(id:) 加载条目资源，并阻止旧请求覆盖新页面。 |
| 33 | [SwiftData：模型、查询和保存失败](lessons/0033-swiftdata-persistence.html) | 32 | 完成学习条目的增删改查，并解释显式保存与内存预览的边界。 |
| 34 | [动画、无障碍与本地化](lessons/0034-accessible-localized-animation.html) | 33 | 让学习条目在大字号、VoiceOver、减少动态效果和两种语言下仍可使用。 |
| 35 | [让业务规则离开 View](lessons/0035-architecture-and-dependencies.html) | 34 | 画出一条“输入 → 校验 → 保存 → 呈现错误”的依赖路径，并替换一个依赖。 |
| 36 | [用测试描述用户能依赖的行为](lessons/0036-behavioral-and-ui-testing.html) | 35 | 为同一功能选择合适的单元、集成和界面验收，并写出失败路径。 |
| 37 | [用 Xcode 解释一次卡顿与一次对象泄漏](lessons/0037-debugging-and-performance.html) | 36 | 采集一段性能证据，指出瓶颈所在，而不是凭 UI 观感猜测。 |
| 38 | [让 Mac 应用像一个 Mac 应用](lessons/0038-macos-windows-and-commands.html) | 37 | 解释窗口状态与应用状态，并验证菜单命令作用于当前窗口。 |
| 39 | [把 UIKit / AppKit 控件接入 SwiftUI](lessons/0039-uikit-appkit-bridges.html) | 38 | 沿着双向数据流解释一次原生文本控件编辑，并避免重复写入。 |
| 40 | [把文件、偏好和敏感数据放在正确位置](lessons/0040-files-secrets-and-privacy.html) | 39 | 完成一个会报告错误的 JSON 导入，并说明不同数据的存储边界。 |
| 41 | [从本地构建走到可交付版本](lessons/0041-build-sign-release.html) | 40 | 区分 build、test、archive、签名与分发，并完成发布前证据清单。 |
| 42 | [读懂宏、所有权与版本边界](lessons/0042-macros-ownership-availability.html) | 41 | 展开一个系统宏，并用编译器观察不可复制值被消耗后的行为。 |
| 43 | [处理生命周期、深链接与后台边界](lessons/0043-lifecycle-deeplinks-background.html) | 42 | 解析一个外部条目链接，并解释 App 进入后台后哪些工作仍有保证。 |
| 44 | [毕业项目：独立完成一个可解释的原生功能](lessons/0044-capstone-and-next-steps.html) | 43 | 完成一个从数据建模到双平台验收的垂直功能，并用证据解释设计选择。 |

## 节奏与复习

建议 12–16 周，每周 4 次、每次 45–75 分钟。一次一到两课：预测 → 运行 → 修改 → 从空白重写关键部分。次日、3 天和 7 天后回忆概念，再按掌握情况调整，不机械追求完成课数。每完成一个阶段，做一次不看答案的里程碑验收。

## 后续专项，不阻塞主线

WidgetKit / App Intents、通知与 APNs、CloudKit 同步、Core Data 旧项目迁移、Combine 维护、StoreKit、Metal、音视频、watchOS / visionOS、深入 SwiftSyntax 宏实现与性能优化可在完成主线后按职业项目选择。当前课程提供相关边界与官方入口，不宣称覆盖每一种 Apple 框架。
