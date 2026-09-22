/// 第 12 课：本类型仅用于同步演示，未声称可以跨并发隔离域共享。
public final class StudyCounter {
    public private(set) var count = 0
    public var onIncrement: (() -> Void)?

    public init() {}

    public func increment() { count += 1 }

    public func installCallback() {
        // self -> 闭包是强引用；闭包 -> self 改成弱引用，避免形成环。
        onIncrement = { [weak self] in
            self?.increment()
        }
    }
}

/// 返回 true 表示即使回调仍被保留，counter 也能够被释放。
public func weakCaptureReleasesOwner() -> Bool {
    var counter: StudyCounter? = StudyCounter()
    let witness = WeakCounter(counter)
    counter?.installCallback()
    let callback = counter?.onIncrement
    callback?()
    counter = nil
    callback?() // 对象已释放，弱引用为 nil；可选调用安全地不执行。
    return witness.value == nil
}

// 观察者不持有对象；用 weak 属性同时兼容 Swift 6.0 的语法基线。
private final class WeakCounter {
    weak var value: StudyCounter?
    init(_ value: StudyCounter?) { self.value = value }
}
