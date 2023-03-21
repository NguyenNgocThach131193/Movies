import RxAlamofire
import Alamofire
import RxSwift
import SwiftyJSON

// MARK: - Request JSON

extension RxBaseService {
    func requestJSON(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: [String : Any]? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil
    ) -> Observable<JSON> {
        return Observable.create { observer -> Disposable in
            return self.request(
                url: url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers,
                observer: observer)
        }
    }

    @discardableResult
    private func request(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: [String : Any]? = nil,
        encoding: ParameterEncoding,
        headers: HTTPHeaders? = nil,
        observer: AnyObserver<JSON>
    ) -> Disposable {
        Logger.log(message: "\n- URL: \(url) \n- Method: \(method.rawValue)\n- PARAMETERS: \(parameters != nil ? JSON(parameters!) : "nil")\n- HEADER: \(headers != nil ? "\(headers!)" : "nil")")

        let onError: (Error) -> Swift.Void = { error in
            Logger.error(message: "\n- URL: \(url) \n\(error)")
            observer.onError(error)
            observer.onCompleted()
        }

        func handleErrorResponse(json: JSON) {
            let metaData = ServiceDataError.parse(json: json)

            if metaData.isUnauthorized && metaData.code == "400001" {
                //                AuthenticationManager.shared.refreshToken(complection: { result in
                //                    switch result {
                //                    case .success(let token):
                //                        let newHeaders = self.headerAfterTokenRefreshed(from: headers, newToken: token.token)
                //                        self.request(url: url, method: method, parameters: parameters, encoding: encoding, headers: newHeaders, observer: observer)
                //                    case .failure(let error):
                //                        Logger.error(message: "\n- URL: \(url) \n\(error)")
                //                        NotificationCenter.default.post(name: .OAuthExpiredEvent, object: nil)
                //                        observer.onError(error)
                //                        observer.onCompleted()
                //                    }
                //                })
            } else {
                onError(metaData)
            }
        }

        let dataRequest = RxAlamofire
            .request(method, url, parameters: parameters, encoding: encoding, headers: headers)
            .validate(contentType: ["application/json"])
            .responseJSON()
            .subscribe(
                onNext: { dataResponse in
                    switch dataResponse.result {
                    case .success(let value):
                        let json = JSON(value)
                        if json["status"].int != nil {
                            handleErrorResponse(json: json)
                        } else {
                            observer.onNext(json)
                            observer.onCompleted()
                        }
                    case .failure(let error):
                        Logger.error(message: "\n- URL: \(url) \n\(error)")
                        if let data = dataResponse.data, let json = try? JSON(data: data), !json.isEmpty {
                            handleErrorResponse(json: json)
                        } else {
                            onError(error)
                        }
                    }
                },
                onError: { error in
                    Logger.error(message: "\n- URL: \(url) \n\(error)")
                    observer.onError(error)
                    observer.onCompleted()
                }
            )
        return dataRequest
    }
}
