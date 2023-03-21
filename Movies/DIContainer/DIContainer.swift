import Foundation
import Swinject

final class DIContainer {
    static let shared = DIContainer()

    private var _threadSafeContainer: Resolver?

    let container = Container()

    var threadSafeContainer: Resolver {
        if _threadSafeContainer == nil {
            _threadSafeContainer = container.synchronize()
        }
        return _threadSafeContainer!
    }

    private init() {
        initImpl()
    }
}
