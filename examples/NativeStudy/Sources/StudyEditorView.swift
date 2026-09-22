import SwiftUI
import SwiftData

@MainActor
struct StudyEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @FocusState private var titleIsFocused: Bool
    @State private var draft: StudyDraft
    @State private var errorMessage: String?
    let item: StudyItem?
    let onSave: (UUID) -> Void

    init(item: StudyItem?, onSave: @escaping (UUID) -> Void) {
        self.item = item
        self.onSave = onSave
        // 只在此视图 identity 首次建立时作为 State 的初始值。
        _draft = State(initialValue: StudyDraft(title: item?.title ?? "", notes: item?.notes ?? ""))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Study topic") {
                    TextField("Title", text: $draft.title, axis: .vertical)
                        .focused($titleIsFocused)
                        .submitLabel(.done)
                        .onSubmit { if draft.isValid { save() } }
                    Text("Use a title containing 1 to 80 characters.")
                        .font(.caption)
                        .foregroundStyle(draft.isValid ? Color.secondary : Color.red)
                }
                Section("Notes") {
                    NotesField(text: $draft.notes)
                }
            }
            .navigationTitle(item == nil ? "New Study Item" : "Edit Study Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) { dismiss() }.keyboardShortcut(.cancelAction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save).disabled(!draft.isValid).keyboardShortcut(.defaultAction)
                }
            }
            .task { titleIsFocused = true }
            .alert("Unable to save", isPresented: Binding(
                get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
                    Button("OK", role: .cancel) { errorMessage = nil }
                } message: { Text(errorMessage ?? "") }
        }
        #if os(macOS)
        .frame(minWidth: 420, minHeight: 340)
        #endif
    }

    private func save() {
        do {
            let saved = try StudyWriter.save(draft, editing: item, in: context)
            onSave(saved.id)
            dismiss() // 只有持久化成功才关闭，失败时保留草稿。
        } catch { errorMessage = error.localizedDescription }
    }
}

@MainActor
private struct NotesField: View {
    @Binding var text: String // 子视图借用父级草稿的读写通道，不再创建第二份 State。
    var body: some View {
        TextEditor(text: $text)
            .frame(minHeight: 120)
            .accessibilityLabel("Notes")
    }
}
