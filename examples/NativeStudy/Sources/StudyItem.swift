import Foundation
import SwiftData

/// 持久化对象留在其 ModelContext 的隔离域内；不要随手标记为 Sendable。
@Model
final class StudyItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var notes: String
    var isCompleted: Bool
    var createdAt: Date

    init(id: UUID = UUID(), title: String, notes: String = "",
         isCompleted: Bool = false, createdAt: Date = .now) {
        self.id = id
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}

/// 值类型草稿将正在编辑的文本与数据库对象分开，取消编辑无需回滚数据库。
struct StudyDraft: Equatable, Sendable {
    var title = ""
    var notes = ""
    var normalizedTitle: String { title.trimmingCharacters(in: .whitespacesAndNewlines) }
    var isValid: Bool { (1...80).contains(normalizedTitle.count) }
}

enum StudyValidationError: LocalizedError {
    case invalidTitle
    case missingItem
    var errorDescription: String? {
        switch self {
        case .invalidTitle:
            String(localized: "Use a title containing 1 to 80 characters.")
        case .missingItem:
            String(localized: "This item was deleted in another window. Cancel this edit or copy your draft into a new item.")
        }
    }
}

@MainActor
enum StudyWriter {
    /// 示例只有一个主 context，且编辑只改草稿。失败回滚全部未提交改动在此边界内是合理的。
    /// 更复杂的多窗口事务应使用各自的 context/repository，不能照搬全局 rollback。
    @discardableResult
    static func save(_ draft: StudyDraft, editing item: StudyItem?, in context: ModelContext) throws -> StudyItem {
        guard draft.isValid else { throw StudyValidationError.invalidTitle }
        // 另一窗口可能在编辑期间删除记录。不能把已脱离 context 的对象当成保存成功。
        if let item {
            guard item.modelContext === context, !item.isDeleted else {
                throw StudyValidationError.missingItem
            }
        }
        let target = item ?? StudyItem(title: draft.normalizedTitle)
        if item == nil { context.insert(target) }
        target.title = draft.normalizedTitle
        target.notes = draft.notes
        do {
            if context.hasChanges { try context.save() }
            return target
        } catch {
            context.rollback()
            throw error // 交给视图显示，不能 try? 吞掉数据丢失。
        }
    }

    static func toggle(_ item: StudyItem, in context: ModelContext) throws {
        item.isCompleted.toggle()
        do { try context.save() }
        catch { context.rollback(); throw error }
    }

    static func delete(_ items: [StudyItem], in context: ModelContext) throws {
        for item in items { context.delete(item) }
        do { try context.save() }
        catch { context.rollback(); throw error }
    }
}
