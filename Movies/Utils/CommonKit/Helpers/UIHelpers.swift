import Foundation
import UIKit

public struct UIHelper {
    public static func dismissKeyboard() {
        func todo() {
            UIApplication.shared.keyWindow?.endEditing(true)
        }

        DispatchQueue.asyncMainSafe {
            todo()
        }
    }

    public static func showNetwordActivityIndicator() {
        OperationQueue.main.addOperation {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    public static func hideNetwordactivityIndicator() {
        OperationQueue.main.addOperation {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
