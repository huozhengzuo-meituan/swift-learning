# ConcurrencyLab · Swift 6 并发实验

配套课程 15–24。所有默认演示与测试均使用内存数据，可离线运行，不会请求公网。代码内有中文注释，先读对应课文，再改一个行为并运行测试。

## 运行

以下命令在 `swift-learning` 工作区根目录执行：

```sh
swift --version
swift test --package-path examples/ConcurrencyLab
swift run --package-path examples/ConcurrencyLab ConcurrencyDemo all
```

也可先 `cd examples/ConcurrencyLab`，再运行 `swift test` 或 `swift run ConcurrencyDemo all`。可用 Xcode 打开本目录的 `Package.swift`，选择 `ConcurrencyDemo` scheme，以 My Mac 运行。

| 课次 | 单独运行的命令末尾 | 主要代码 |
|---|---|---|
| 15 async / await | `ConcurrencyDemo async` | `Sources/ConcurrencyKit/StructuredWork.swift`：`loadName` |
| 16 async let | `ConcurrencyDemo children` | 同上：`loadDashboard` |
| 17 TaskGroup | `ConcurrencyDemo group` | 同上：`orderedMap` |
| 18 取消 | `ConcurrencyDemo cancel` | 同上：`cancellableSum` |
| 19 actor 重入 | `ConcurrencyDemo actor` | 同上：`SeatInventory` |
| 20 Sendable / sending | `ConcurrencyDemo sendable` | 同上：`ReadingSnapshot`、`DraftInbox` |
| 21 MainActor | `ConcurrencyDemo mainactor` | `Sources/ConcurrencyKit/Networking.swift`：`ProfileScreenModel` |
| 22 HTTP 与 fixture | `ConcurrencyDemo network` | 同上：`ProfileClient`、`HTTPTransport` |
| 23 流与回调 | `ConcurrencyDemo stream` | `Sources/ConcurrencyKit/Streams.swift` |
| 24 迁移里程碑 | `ConcurrencyDemo migration`，随后 `all` | `Package.swift`、全部行为测试 |

例如完整单课命令为：

```sh
swift run --package-path examples/ConcurrencyLab ConcurrencyDemo actor
swift test --package-path examples/ConcurrencyLab --filter reservationMaintainsInvariantAcrossSuspension
```

`all` 依次执行每个演示分支。任务调度先后不作保证；actor 演示应输出成功数 `1`、余量 `0`。`group` 应输出 `[9, 1, 4]`。进度流缓冲策略为 `bufferingNewest(1)`，慢消费者可能跳过中间值，但最终值是 `3`。不要把输出顺序和短睡眠耗时当作性能或调度保证。

## 基线与验证边界

- manifest：`swift-tools-version: 6.0`；源代码语言模式：`.v6`。
- 平台声明：macOS 14 / iOS 17。CLI 运行目标是 macOS；库可供后续 iOS 项目使用。
- 显式标注 `@MainActor`；未设置默认 MainActor，未开启 upcoming feature flags。
- 2026-09-22 本机使用 Apple Swift 6.4 编译通过，14 个 Swift Testing 行为测试通过，`ConcurrencyDemo all` 运行通过。未使用 Swift 6.0 编译器实测，也未在 iOS 真机执行此包。
- `swift test` 可能先打印 XCTest 的 “Executed 0 tests”，随后 Swift Testing 会打印实际的 14 个测试结果；以末尾 `Test run with 14 tests ... passed` 为准。

6.2 起可配置默认 actor 隔离和非隔离 async 的调用者隔离语义。它们与语言模式独立；不要把课文中的 6.2 manifest 配置直接复制进本包的 tools 6.0 manifest。`sending` 自 Swift 6.0 起可用，包中已有可运行示例。

## 测试如何证明行为

`Tests/ConcurrencyKitTests/ConcurrencyKitTests.swift` 包含 14 个测试，覆盖：

- 固定子任务汇合；动态任务组还原输入顺序、空输入、错误取消并等待兄弟任务。
- CPU 工作主动响应取消。
- actor 挂起期间的占位不变量，以及失败/取消后的库存回滚。
- 合法 JSON、HTTP 503、非 HTTP 响应、字段类型不匹配。
- 旧请求最后返回也不能覆盖新界面。
- 流完成、消费者取消、提前退出显式关闭、回调桥接成功/失败。
- 非 Sendable 草稿的 `sending` 交接。

`Gate` 只在测试中固定挂起与恢复顺序，避免用固定 sleep 猜测竞态。它不是生产取消适配器。任务组测试内的 30 秒 sleep 是等待取消的兄弟任务，正常测试应立即取消它；它不是测试需要等待的时长。

## 练习边界

`LiveTransport` 是可替换的 URLSession 实现，但演示默认使用 `FixtureTransport`。真实接入还需按接口契约设计认证、缓存、超时、错误展示；不要在代码里保存凭据。

`SeatInventory` 演示本进程内状态一致性。确认失败时加回库存不等于回滚一次真实外部支付；跨系统事务需要另外设计幂等与补偿。

`legacyTitle` 明确保证同步回调恰好一次，因此 `bridgedTitle` 能简单使用 checked continuation。真实 API 若可能重复/遗漏回调或提供取消 token，需要额外的同步与取消协议；本例不宣称是所有旧 API 的通用适配器。

`orderedMap` 为教学一次提交整个输入；大型列表应在理解任务组后增加并发窗口。`cancellableSum` 只使用演示中的小整数范围，不把该例当作大整数算法。

## 里程碑

关闭课文，解释为什么 actor 仍可能超售、MainActor 仍可能发布旧结果、提前 `break` 后仍需关闭流。随后独立运行测试、改出一个故障、说明失败原因并修复。把过程记录到学习记录中；生成课程或测试通过不自动表示已掌握。
