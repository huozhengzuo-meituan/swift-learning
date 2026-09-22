import SwiftUI
import UniformTypeIdentifiers

/// 独立练习片段：小文件导入。正式产品需增加大小限制、后台 I/O、schema 校验。
@MainActor
struct ImportWorkshop: View {
    @State private var importing = false
    @State private var status = "选择一个小型 JSON 文件"
    var body: some View {
        VStack(spacing: 12) {
            Button("导入 JSON") { importing = true }
            Text(status)
        }
        .padding()
        .fileImporter(isPresented: $importing, allowedContentTypes: [.json]) { result in
            do {
                let url = try result.get()
                let hasAccess = url.startAccessingSecurityScopedResource()
                // 仅对成功取得的授权成对释放；容器内 URL 可能不需要额外授权。
                defer { if hasAccess { url.stopAccessingSecurityScopedResource() } }
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode([ImportedItem].self, from: data)
                // 完整解析后再更新状态，避免失败时部分导入。
                status = "已验证 \(decoded.count) 条记录；此实验尚未写入数据库"
            } catch {
                status = "导入失败：\(error.localizedDescription)"
            }
        }
    }
}
private struct ImportedItem: Decodable { let title: String }
