// swift -swift-version 6 examples/PlatformRecipes/Ownership.swift
// ~Copyable 从 Swift 5.9 起可用；本课程统一用 Swift 6 语言模式。
struct ExportTicket: ~Copyable {
    let filename: String
    // borrowing 只读取，调用结束后仍由调用方持有。
    borrowing func preview() -> String { "准备导出：\(filename)" }
    // consuming 消耗这个值；之后不能再次使用原来的变量。
    consuming func finish() { print("已完成：\(filename)") }
}
func run() {
    let ticket = ExportTicket(filename: "study.json")
    print(ticket.preview())
    ticket.finish()
    // 练习：取消下一行注释，观察编译器拒绝消耗后的再次使用。
    // print(ticket.preview())
}
run()
