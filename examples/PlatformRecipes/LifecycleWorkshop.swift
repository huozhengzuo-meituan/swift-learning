import SwiftUI
import OSLog

/// 练习片段，无 @main。可放入 NativeStudy 的 Sources，在 #Preview 中体验。
/// 如要让自定义 scheme 从系统启动应用，还需配置 URL Types；此片段只演示解析。
@MainActor
struct LifecycleWorkshop: View {
    @Environment(\.scenePhase) private var phase
    @State private var selectedID: UUID?
    @State private var message = "等待链接"
    private let logger = Logger(subsystem: "learning.native", category: "lifecycle")

    var body: some View {
        VStack(spacing: 16) {
            Text(message)
            Text(selectedID?.uuidString ?? "尚未选择条目")
                .textSelection(.enabled)
        }
        .padding()
        .onChange(of: phase) { _, newPhase in
            // 记录非敏感生命周期信息；后台状态不是无限执行许可证。
            logger.info("Scene phase: \(String(describing: newPhase), privacy: .public)")
        }
        .onOpenURL { url in
            // 外部输入始终校验；真实应用还需查库确认条目存在。
            guard url.scheme == "nativestudy", url.host == "item",
                  let id = UUID(uuidString: url.lastPathComponent) else {
                message = "链接格式不正确"
                return
            }
            selectedID = id
            message = "链接已解析，下一步按 ID 查询数据"
        }
    }
}
