# 课程与示例验证记录

核对日期：2026-09-22。材料验证不代表学习者已完成课程。

## 实际环境与声明基线

| 项目 | 值 |
|---|---|
| 主机 | arm64，macOS 27.0（26A428） |
| Xcode | 27.0（27A266a） |
| 编译器 | Apple Swift 6.4（swiftlang-6.4.0.34.1） |
| 语言模式 | Swift 6，示例显式配置 |
| SwiftPM tools | 6.0 |
| 声明部署下限 | NativeStudy：iOS 17 / macOS 14 |
| 本次 iOS 编译 SDK | iOS Simulator 27.0，generic simulator destination |

编译器、语言模式、SDK、最低系统和实际运行系统是不同事实。本机版本只记录观察值，不推断其公开发布状态。

## 已完成的代码验证

| 范围 | 命令/方式 | 实际结果 |
|---|---|---|
| SwiftFoundations | `swift test --package-path examples/SwiftFoundations` | 13 项 Swift Testing 测试通过；其中 1 项包含 5 个参数化案例 |
| 基础演示 | `swift run --package-path examples/SwiftFoundations foundation-lab all` | 14 个演示全部运行成功 |
| ConcurrencyLab | `swift test --package-path examples/ConcurrencyLab` | 14 项测试通过 |
| 并发演示 | `swift run --package-path examples/ConcurrencyLab ConcurrencyDemo all` | 全部演示运行成功 |
| NativeStudy macOS | Xcode macOS scheme `test`，无签名，My Mac | 10 项 Swift Testing 测试通过；BUILD/TEST 成功 |
| NativeStudy iOS | Xcode iOS scheme `build`，无签名，generic iOS Simulator | 构建成功 |
| PlatformRecipes | Ownership / TypedThrows 运行；Import/Lifecycle `swiftc -typecheck` | 合法片段通过；故意重复使用 consuming 值时得到预期编译失败 |

合计 **37 项 Swift Testing 测试**。Swift Testing 与 XCTest 输出同时出现时，不以 XCTest 的 “0 tests” 推断整个测试过程没有执行。

最终从根目录完整执行 `bash scripts/verify.sh`，退出码 **0**。汇总日志保存在本机 `artifacts/verify.log`（构建产物与日志已被 Git 忽略）；日志包含 13 / 14 / 10 项测试通过、macOS `TEST SUCCEEDED` 和 iOS Simulator `BUILD SUCCEEDED`。

测试包括输入校验、Unicode、值语义、ARC、JSON、幂等修改；并发的取消、actor 预留与回滚、任务组错误、HTTP/解码失败、AsyncStream 清理、迟到结果保护；SwiftData 保存/删除读回、取消草稿隔离、跨窗口删除后编辑失败等。

## 已完成的运行观察

在 macOS 应用实际操作并观察了：新增与保存、取消编辑不污染原标题、完成状态与列表变化、进入原生桥接练习、AppKit 文本变化同步到 SwiftUI、中文文案显示。此记录为交互冒烟检查，不是完整 UI 自动化套件。

课程网页通过独立浏览器会话检查：桌面排版、SwiftUI 模块筛选（10 课）、`actor` 搜索（2 课）、390×844 手机尺寸无横向溢出、正确/错误自测反馈、进度刷新后保留、单课导出按钮，以及速查卡打印 PDF 的首页可读性。测试后撤销进度，恢复 **0/44**。小屏进度行与打印代码块的换行样式已据此调整。

## 审查与修复

- 独立 Swift 代码审查发现：条目在另一窗口删除后，编辑页曾误报保存成功。现检查模型所属上下文与删除状态，保留草稿并报告错误，已有回归测试。
- 异步乱序测试曾依赖 `Task.yield()` 调度假设。现使用显式 actor 门闩等待请求进入，再控制返回顺序；预先取消也有独立测试。
- JavaScript 审查核对了本地服务器的 GET/HEAD、方法拒绝、非法路径、路径穿越与目录处理；未发现阻塞级问题。
- 页面进度导出在每课提供；测验混合正确/错误陈述，避免固定答案模式。
- 44 课正文、5 份速查与首页共 50 个 HTML 文件，1,111 个本地路径/锚点检查通过；每课均有实质正文、练习、解法、测验和官方引用。
- 语法速查的 4 个代码块合并后在 Swift 6 模式下运行通过；验证脚本经独立检查并通过 `bash -n`。

## 明确未验证

- iOS 真实触摸交互、真机、iOS 17 / macOS 14 最低系统与原始 Swift 6.0 编译器。
- VoiceOver、最大 Dynamic Type、中文输入法完整组合输入矩阵、所有多窗口路径。
- 真实磁盘满/权限故障、旧版本数据库迁移、发布环境的网络和后端。
- 分发签名、Archive 上传、公证、TestFlight 或商店发布。

这些项目在课程中提供步骤和验收要求，不在本次已通过清单中。重新验证可执行 `bash scripts/verify.sh`，操作级验证按项目 README 和 CAPSTONE.md 逐项记录。
