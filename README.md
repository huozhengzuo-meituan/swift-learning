# Swift / Native Lab

面向 Web 前端工程师的中文 Apple 原生开发课程。**44 节完整课程、3 个可运行项目、5 份速查卡**，以及补充实验与毕业项目任务书。

## 从这里开始

```sh
# 在 swift-learning 工作区根目录执行
open index.html
```

课程无需构建网页、安装前端依赖或联网即可阅读和自测。外部官方资料需联网。若更喜欢 localhost（Node 22+）：

```sh
node scripts/serve.mjs
# 在浏览器打开 http://127.0.0.1:8766
```

先看 [完整大纲](CURRICULUM.md)，再学习 [第 1 课](index.html#curriculum)。每课按“预测 → 运行 → 修改 → 独立练习 → 回忆”的顺序。建议 12–16 周完成，时间可调整；课程已经一次生成，无需等待逐课创建。

## 项目怎么运行

需要完整 Xcode 工具链，主线语言基线为 Swift 6（通常 Xcode 16+）。本次实际验证环境是 Xcode 27.0 / Swift 6.4；最低版本编译器与最低系统未逐一实测，详见 [验证记录](VERIFICATION.md)。

| 项目 | 内容 | 从根目录执行 |
|---|---|---|
| [SwiftFoundations](examples/SwiftFoundations/README.md) | 语言、类型建模、错误处理、测试 | 见项目 README 的 demo 命令 |
| [ConcurrencyLab](examples/ConcurrencyLab/README.md) | async/await、actor、Sendable、网络 fixture | `swift run --package-path examples/ConcurrencyLab ConcurrencyDemo all` |
| [NativeStudy](examples/NativeStudy/README.md) | iOS/macOS SwiftUI + SwiftData 学习管理应用 | `open examples/NativeStudy/NativeStudy.xcodeproj` |

NativeStudy 选择 `NativeStudy-macOS` + My Mac，或 `NativeStudy-iOS` + 可用 iPhone/iPad Simulator，再按 ⌘R。已包含 Xcode 工程，运行不需要安装 XcodeGen；仅重建工程配置时才用项目中的 project.yml。

```sh
swift test --package-path examples/SwiftFoundations
swift test --package-path examples/ConcurrencyLab
bash scripts/verify.sh
```

学习示例不需要第三方 Swift 包、后端或 API Key。网络行为使用明确标注的固定数据实验；本地构建不要求购买开发者会员，真机安装与分发需要另行配置签名。

## 技术基线

- Swift 6 语言模式、完整数据竞争检查；UI 状态用明确的 `@MainActor`。Swift 6.2+ 的默认隔离等差异在第 24 课独立说明。
- SwiftUI、Observation、NavigationStack / NavigationSplitView、SwiftData；部署下限 iOS 17 / macOS 14。
- Swift Testing 验证规则、并发和存储行为；UI 自动化采用 XCTest / XCUIAutomation 的工程路线，实际执行范围单独记录。
- 平台控件桥接、窗口/命令、动态文字、本地化与可访问性纳入课程，不只做成功页面。

## 文件地图

| 路径 | 用途 |
|---|---|
| `index.html` / `lessons/` | 离线课程入口与逐课正文 |
| `content/*.json` | 课程原始内容；不是待补齐的大纲 |
| `assets/` | 共用排版、打印样式、即时测验与自报进度 |
| `reference/` | 5 份可打印速查卡 |
| `examples/PlatformRecipes/` | 所有权、文件导入与生命周期补充片段 |
| `MISSION.md` / `learning-records/` | 学习目标与真实掌握证据 |
| `RESOURCES.md` | 官方资料和实践社区索引 |
| `CAPSTONE.md` | 毕业项目需求与评分标准 |

## 内容维护

Node 22+ 仅用于生成、检查或本地服务，直接阅读不需要它。

```sh
node scripts/build-course.mjs
node scripts/check-course.mjs
```

浏览器进度只代表自己确认已做练习，不会自动写入 learning-records。可以导出 JSON 留存；个人能力验收由练习结果与后续答疑支持。
