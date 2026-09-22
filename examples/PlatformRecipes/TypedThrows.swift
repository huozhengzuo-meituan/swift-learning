// 根目录运行：swift -swift-version 6 examples/PlatformRecipes/TypedThrows.swift
// SE-0413：typed throws 自 Swift 6.0 起可用。
// 本例是错误集合固定的本地校验，不涉及网络、JSON 或取消等其他失败来源。
enum MinutesError: Error {
    case outOfRange(Int)
}

func validatedMinutes(_ value: Int) throws(MinutesError) -> Int {
    guard (1...180).contains(value) else { throw MinutesError.outOfRange(value) }
    return value
}

for candidate in [25, 0, 181] {
    do {
        print("有效分钟：\(try validatedMinutes(candidate))")
    } catch {
        // 此 do 中只有一种可抛出的错误，error 的静态类型就是 MinutesError。
        // 不需要 as? 强转；switch 必须覆盖自有枚举的全部情况。
        switch error {
        case .outOfRange(let value):
            print("拒绝 \(value)：分钟须在 1...180 范围内")
        }
    }
}

// 练习：临时把 throws(MinutesError) 改成 throws，再编译。
// catch 中的 error 将变成 any Error，原来的穷尽 switch 不再足够。
// 恢复后再次运行。接入多种外部失败来源时，普通 throws 往往更合适。
