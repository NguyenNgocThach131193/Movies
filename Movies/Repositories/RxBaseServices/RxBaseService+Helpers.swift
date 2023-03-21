import Alamofire

extension Notification.Name {
    static let OAuthExpiredEvent = Notification.Name("OAuthExpiredEvent")
}

// MARK: - Helpers
extension RxBaseService {
    func headers() -> HTTPHeaders {
        var httpHeaders = HTTPHeaders()
        let contentType = HTTPHeader.contentType("application/json")
        let accept = HTTPHeader.accept("application/json")

        return HTTPHeaders([contentType, accept])
    }
}
