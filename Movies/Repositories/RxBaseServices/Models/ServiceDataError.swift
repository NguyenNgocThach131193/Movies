import SwiftyJSON
import Alamofire

public struct ServiceDataError: Error, JSONAdapterObject {
    struct ErrorCode {
        static let unAuthorized = 401
    }

    public typealias ModelType = ServiceDataError
    let code: String
    let status: Int
    let message: String
    let timestamp: String
    let traceId: String

    public static func parse(json: JSON) -> ServiceDataError {
        return ServiceDataError(
            code: json["code"].stringValue,
            status: json["status"].intValue,
            message: json["message"].stringValue,
            timestamp: json["timestamp"].stringValue,
            traceId: json["traceId"].stringValue)
    }

    var errorMessage: String {
        return message
    }

    var isUnauthorized: Bool {
        return status == ErrorCode.unAuthorized
    }
}
