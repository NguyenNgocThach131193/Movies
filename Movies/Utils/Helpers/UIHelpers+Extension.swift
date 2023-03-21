import Foundation
import PKHUD

extension UIHelper {
    static func showLoading() {
        func show() {
            HUD.show(.progress)
        }

        if Thread.isMainThread {
            show()
        } else {
            DispatchQueue.main.async {
                show()
            }
        }
    }

    static func hideLoading() {
        func hide() {
            HUD.hide()
        }

        if Thread.isMainThread {
            hide()
        } else {
            DispatchQueue.main.async {
                hide()
            }
        }
    }

    static func showServiceLoading(title: String = "Loading.Title".localized()) {
        func show() {
            UIHelper.showNetwordActivityIndicator()
            showLoading()
        }

        if Thread.isMainThread {
            show()
        } else {
            DispatchQueue.main.async {
                show()
            }
        }
    }

    static func hideServiceLoading() {
        func hide() {
            UIHelper.hideNetwordactivityIndicator()
            HUD.hide()
        }

        if Thread.isMainThread {
            hide()
        } else {
            DispatchQueue.main.async {
                hide()
            }
        }
    }

    static func showPopup(
        title: String,
        message: String,
        positiveTitle: String = "OKButton.title".localized(),
        presenter: UIViewController,
        handler: (() -> Void)? = nil
    ) {
        UIHelper.hideServiceLoading()
        UIHelper.dismissKeyboard()
        func show() {

        }

        if Thread.isMainThread {
            show()
        } else {
            DispatchQueue.main.async {
                show()
            }
        }
    }

    static func showError(
        error: Error,
        presenter: UIViewController,
        handler: (() -> Void)? = nil
    ) {
        let mesageError = error.errorMessage()
        showPopup(
            title: "PopupControl.Error.Default.Title".localized(),
            message: mesageError,
            positiveTitle: "OKButton.title".localized(),
            presenter: presenter,
            handler: handler
        )
    }
}
