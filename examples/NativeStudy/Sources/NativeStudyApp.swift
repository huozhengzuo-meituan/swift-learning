import SwiftUI
import SwiftData

@main
@MainActor
struct NativeStudyApp: App {
    @State private var preferences = StudyPreferences()
    private let storage: Result<ModelContainer, Error>
    @FocusedValue(\.newStudyItem) private var newStudyItem

    init() {
        storage = Result {
            let configuration = ModelConfiguration(cloudKitDatabase: .none)
            let container = try ModelContainer(for: StudyItem.self, configurations: configuration)
            // 练习显式保存及失败反馈，避免依赖自动保存的时机。
            container.mainContext.autosaveEnabled = false
            return container
        }
    }

    var body: some Scene {
        WindowGroup {
            switch storage {
            case .success(let container):
                StudyListView()
                    .environment(preferences)
                    .modelContainer(container)
            case .failure(let error):
                ContentUnavailableView {
                    Label("Unable to open storage", systemImage: "externaldrive.badge.exclamationmark")
                } description: {
                    Text(error.localizedDescription)
                    Text("Your existing data has not been deleted. Close the app and investigate the storage error.")
                }
                .padding()
            }
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("New Study Item") { newStudyItem?() }
                    .keyboardShortcut("n", modifiers: [.command, .shift])
                    .disabled(newStudyItem == nil)
            }
        }
        #if os(macOS)
        Settings {
            PreferencesView().environment(preferences)
                .frame(width: 380)
        }
        #endif
    }
}

struct NewStudyItemKey: FocusedValueKey {
    typealias Value = @MainActor () -> Void
}
extension FocusedValues {
    var newStudyItem: NewStudyItemKey.Value? {
        get { self[NewStudyItemKey.self] }
        set { self[NewStudyItemKey.self] = newValue }
    }
}

@MainActor
struct PreferencesView: View {
    @Environment(StudyPreferences.self) private var preferences
    var body: some View {
        @Bindable var preferences = preferences
        Form {
            Toggle("Show completed items", isOn: $preferences.showCompleted)
            Toggle("Simulate resource failure", isOn: $preferences.simulateResourceFailure)
            Text("These preferences last for the current app session.")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Settings")
    }
}
