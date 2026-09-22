# Swift Learning 教学工作区

本目录是长期教学工作区。先读 MISSION.md、NOTES.md 和 learning-records，依据用户已展示的能力答疑。

- 一次准备完整课程的要求已落实；日后按需讲解、纠错与拓展，不默认每次重新生成课程。
- 权威来源使用 Swift.org、Swift 官方文档与提案、Apple Developer 文档/WWDC/HIG。涉及新版本和 API 可用性时先验证。
- 正文在 content/*.json，运行 node scripts/build-course.mjs 生成 index.html、lessons/*.html 和 CURRICULUM.md。共享组件在 assets/，不要仅改生成页面。
- 每课保留目标、先修、具体解释、示例、练习、解法、自测、回忆问题与来源。参考资料在 reference/。
- 示例统一 Swift 6 语言模式；默认隔离明确表达。编译器版本、语言模式、SDK 与部署版本分别记录。
- 课程生成、代码测试通过、用户掌握三者是不同事实。仅用户展示理解后新增 learning-records。
- 不自动提交 Git、不发布应用；验证命令见 README.md 与 scripts/verify.sh。

## 用户指定的内网访问规范

- `.sankuai.com`（除 `km.sankuai.com`）与 `.meituan.com` URL 必须经 Bash 的 agent-browser，禁止 WebFetch。先 `agent-browser get url`；正常则 goto，未启动则 open --headed --no-sandbox，超过 10 秒无响应才按用户给定流程清理僵尸浏览器。禁止每次重开、禁止不存在的 launch 命令。
- `km.sankuai.com` 学城文档使用 citadel skill 读写，不使用浏览器。
- max / leez 相关编码之前，先通过 max-kb-retrieval-server MCP 获取详细文档。
