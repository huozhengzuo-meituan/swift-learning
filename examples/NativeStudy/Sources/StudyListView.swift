import SwiftUI
import SwiftData

@MainActor
struct StudyListView: View {
    @Environment(\.modelContext) private var context
    @Environment(StudyPreferences.self) private var preferences
    @Query(sort: \StudyItem.createdAt, order: .reverse) private var items: [StudyItem]
    @State private var selection: UUID?
    @State private var search = ""
    @State private var editor: EditorRequest?
    @State private var showingSettings = false
    @State private var errorMessage: String?

    private var visibleItems: [StudyItem] {
        // 教学规模在内存过滤；数据量大时应将筛选条件下推为 Query 的 predicate。
        items.filter { item in
            (preferences.showCompleted || !item.isCompleted)
                && (search.isEmpty || item.title.localizedCaseInsensitiveContains(search))
        }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(visibleItems) { item in
                    NavigationLink(value: item.id) { StudyRow(item: item) }
                        .contextMenu {
                            Button("Edit") { editor = EditorRequest(item: item) }
                            Button("Delete", role: .destructive) { delete([item]) }
                        }
                }
                .onDelete { offsets in
                    // offsets 属于过滤后的视图集合，不能拿它去索引原始 items。
                    delete(offsets.map { visibleItems[$0] })
                }
            }
            .overlay {
                if visibleItems.isEmpty {
                    ContentUnavailableView("No study items", systemImage: "book.closed", description: Text("Add a topic or adjust your search."))
                }
            }
            .navigationTitle("Native Study")
            .searchable(text: $search, prompt: "Search titles")
            .toolbar {
                ToolbarItem {
                    Button("New Study Item", systemImage: "plus") { editor = EditorRequest(item: nil) }
                }
                #if os(iOS)
                ToolbarItem {
                    Button("Settings", systemImage: "gear") { showingSettings = true }
                }
                #endif
            }
        } detail: {
            NavigationStack {
                if let selection, let item = visibleItems.first(where: { $0.id == selection }) {
                    StudyDetailView(item: item) { editor = EditorRequest(item: item) }
                        .id(item.id) // 更换条目重建其局部视图状态；条目 ID 本身必须稳定。
                } else {
                    ContentUnavailableView("Select a study item", systemImage: "book")
                }
            }
        }
        .focusedSceneValue(\.newStudyItem, { editor = EditorRequest(item: nil) })
        .sheet(item: $editor) { request in
            StudyEditorView(item: request.item) { savedID in selection = savedID }
        }
        .sheet(isPresented: $showingSettings) {
            NavigationStack {
                PreferencesView()
                    .toolbar { Button("Done") { showingSettings = false } }
            }
        }
        .alert("Unable to save", isPresented: showingError) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: { Text(errorMessage ?? "") }
        #if os(macOS)
        .frame(minWidth: 760, minHeight: 520)
        #endif
    }

    private var showingError: Binding<Bool> {
        Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })
    }
    private func delete(_ targets: [StudyItem]) {
        let deletedIDs = Set(targets.map(\.id))
        do {
            try StudyWriter.delete(targets, in: context)
            if let selection, deletedIDs.contains(selection) { self.selection = nil }
        } catch { errorMessage = error.localizedDescription }
    }
}

private struct EditorRequest: Identifiable {
    let id = UUID()
    let item: StudyItem?
}

@MainActor
struct StudyRow: View {
    let item: StudyItem
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(item.isCompleted ? Color.green : Color.secondary)
                .accessibilityLabel(item.isCompleted ? Text("Completed") : Text("In progress"))
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).font(.headline)
                Text(item.createdAt, format: .dateTime.month().day()).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

#Preview("Seeded in-memory data") {
    StudyPreview()
}

@MainActor
private struct StudyPreview: View {
    private let storage: Result<ModelContainer, Error> = Result {
        let container = try ModelContainer(for: StudyItem.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true, cloudKitDatabase: .none))
        container.mainContext.insert(StudyItem(title: "SwiftUI 数据流", notes: "解释 State 与 Binding 的职责。"))
        return container
    }
    var body: some View {
        switch storage {
        case .success(let container):
            StudyListView().environment(StudyPreferences()).modelContainer(container)
        case .failure(let error): Text(error.localizedDescription)
        }
    }
}
