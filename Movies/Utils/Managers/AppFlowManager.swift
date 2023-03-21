import UIKit
import RxSwift

class AppFlowManager: NSObject {
    static let shared = AppFlowManager()

    let backgroundWorkScheduler: ImmediateSchedulerType

    override init() {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
    }
}
