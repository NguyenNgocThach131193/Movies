import Foundation

public extension DispatchQueue {
    /// A Boolean value indicating whether the current
    /// dispatch queue is the main queue.
    static var isMainQueue: Bool {
        enum Static {
            static var key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
                DispatchQueue.main.setSpecific(key: key, value: ())
                return key
            }()
        }
        return DispatchQueue.getSpecific(key: Static.key) != nil
    }
}

public extension DispatchQueue {
    static func asyncMainSafe(_ complection: @escaping () -> Swift.Void) {
        if Thread.isMainThread {
            complection()
        } else {
            DispatchQueue.main.async {
                complection()
            }
        }
    }

    static func syncMainSafe(_ complection: @escaping () -> Swift.Void) {
        if Thread.isMainThread {
            complection()
        } else {
            DispatchQueue.main.sync {
                complection()
            }
        }
    }
}
