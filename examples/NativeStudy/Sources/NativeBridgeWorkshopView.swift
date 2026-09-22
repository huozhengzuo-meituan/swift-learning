import SwiftUI

@MainActor
struct NativeBridgeWorkshopView: View {
    @State private var value = "SwiftUI owns this value"
    var body: some View {
        Form {
            TextField("SwiftUI text", text: $value)
            // 同一状态同时驱动 SwiftUI TextField 与平台文本控件。
            PlatformTextField(text: $value).frame(minHeight: 32)
                .accessibilityLabel("Native text")
            Text(value)
        }
        .padding()
        .navigationTitle("Native bridge workshop")
    }
}

#if os(iOS)
import UIKit

@MainActor
struct PlatformTextField: UIViewRepresentable {
    @Binding var text: String
    func makeCoordinator() -> Coordinator { Coordinator(text: $text) }
    func makeUIView(context: Context) -> UITextField {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.font = .preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        field.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .editingChanged)
        return field
    }
    func updateUIView(_ field: UITextField, context: Context) {
        context.coordinator.text = $text
        // 正在组合输入（例如中文拼音）时不要覆盖原生编辑缓冲区。
        guard field.markedTextRange == nil, field.text != text else { return }
        field.text = text
    }
    @MainActor
    final class Coordinator: NSObject {
        var text: Binding<String>
        init(text: Binding<String>) { self.text = text }
        @objc func changed(_ field: UITextField) {
            guard field.markedTextRange == nil else { return }
            text.wrappedValue = field.text ?? ""
        }
    }
}
#elseif os(macOS)
import AppKit

@MainActor
struct PlatformTextField: NSViewRepresentable {
    @Binding var text: String
    func makeCoordinator() -> Coordinator { Coordinator(text: $text) }
    func makeNSView(context: Context) -> NSTextField {
        let field = NSTextField(string: text)
        field.delegate = context.coordinator
        field.isEditable = true
        return field
    }
    func updateNSView(_ field: NSTextField, context: Context) {
        context.coordinator.text = $text
        guard (field.currentEditor() as? NSTextView)?.hasMarkedText() != true, field.stringValue != text else { return }
        field.stringValue = text
    }
    @MainActor
    final class Coordinator: NSObject, NSTextFieldDelegate {
        var text: Binding<String>
        init(text: Binding<String>) { self.text = text }
        func controlTextDidChange(_ notification: Notification) {
            guard let field = notification.object as? NSTextField,
                  (field.currentEditor() as? NSTextView)?.hasMarkedText() != true else { return }
            text.wrappedValue = field.stringValue
        }
    }
}
#endif
