import Foundation

struct Enpoint {
    static let APIEndPoint = "http://www.omdbapi.com"
}

typealias ResultHandler<Success> = (_ result: Result<Success, Error>) -> Void
