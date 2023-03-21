import SwiftyJSON

extension String: Error { }

extension JSON {
    public func getMessageError() -> String {
        if let errorMessage = self["message"].string {
            return errorMessage
        } else {
            return "Service.Error.DefaultMessage".localized()
        }
    }
}

extension Error {
    public func errorMessage() -> String {
        if let errorString = self as? String {
            return errorString.localized()
        } else if let message = (self as NSError).userInfo["message"] as? String {
            return message.localized()
        } else if let metaDataError = self as? ServiceDataError {
            return metaDataError.errorMessage.localized()
        } else {
            return "Service.Error.DefaultMessage".localized()
        }
    }
}
