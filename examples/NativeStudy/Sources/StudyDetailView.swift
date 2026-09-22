import SwiftUI
import SwiftData

private enum DetailRoute: Hashable { case layoutWorkshop, nativeBridge }
private struct ResourceRequest: Equatable {
    let topic: String
    let shouldFail: Bool
    let retry: Int
}

@MainActor
struct StudyDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(StudyPreferences.self) private var preferences
    @State private var loader = ResourceLoader()
    @State private var retry = 0
    @State private var errorMessage: String?
    let item: StudyItem
    let onEdit: () -> Void

    var body: some View {
        Form {
            Section("Study topic") {
                Text(item.title).font(.title2).textSelection(.enabled)
                if !item.notes.isEmpty { Text(item.notes).textSelection(.enabled) }
                Button(action: toggleCompleted) {
                    Label(item.isCompleted ? "Mark in progress" : "Mark completed",
                          systemImage: item.isCompleted ? "arrow.uturn.backward" : "checkmark.circle")
                }
                Text(item.isCompleted ? "Completed" : "In progress")
                    .foregroundStyle(.secondary)
                    .contentTransition(.opacity)
            }
            Section("Reading resources") {
                Text("Offline fixture: loading is simulated; opening a link requires the internet.")
                    .font(.caption).foregroundStyle(.secondary)
                switch loader.state {
                case .idle, .loading: ProgressView("Loading resources")
                case .loaded(let resources):
                    ForEach(resources) { resource in Link(resource.title, destination: resource.url) }
                case .failed(let message):
                    Text(message).foregroundStyle(.red)
                    Button("Retry") { retry += 1 }
                }
            }
            Section("Workshops") {
                NavigationLink("Layout workshop", value: DetailRoute.layoutWorkshop)
                NavigationLink("Native bridge workshop", value: DetailRoute.nativeBridge)
            }
        }
        .navigationTitle("Study details")
        .toolbar { Button("Edit", action: onEdit) }
        .navigationDestination(for: DetailRoute.self) { route in
            switch route {
            case .layoutWorkshop: LayoutWorkshopView()
            case .nativeBridge: NativeBridgeWorkshopView()
            }
        }
        .task(id: ResourceRequest(topic: item.title, shouldFail: preferences.simulateResourceFailure, retry: retry)) {
            await loader.load(topic: item.title, shouldFail: preferences.simulateResourceFailure)
        }
        .alert("Unable to save", isPresented: Binding(
            get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
                Button("OK", role: .cancel) { errorMessage = nil }
            } message: { Text(errorMessage ?? "") }
    }

    private func toggleCompleted() {
        do {
            try withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
                try StudyWriter.toggle(item, in: context)
            }
        } catch { errorMessage = error.localizedDescription }
    }
}

@MainActor
struct LayoutWorkshopView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Modifier order changes the result.").font(.title2)
                Text("Padding then background")
                    .padding(24).background(.blue.opacity(0.2))
                Text("Background then padding")
                    .background(.blue.opacity(0.2)).padding(24)
                Text("Resize the window or increase text size. Prefer semantic fonts and flexible layout over fixed text heights.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Layout workshop")
    }
}
