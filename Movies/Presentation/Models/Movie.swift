import SwiftyJSON

struct Movie: JSONAdapterObject {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String

    typealias ModelType = Movie
    static func parse(json: JSON) -> Movie {
        Movie(
            title: json["Title"].stringValue,
            year: json["Year"].stringValue,
            imdbID: json["imdbID"].stringValue,
            type: json["Type"].stringValue,
            poster: json["Poster"].stringValue
        )
    }
}

struct MoviesResult: JSONAdapterObject {
    let totalResult: Int
    let movies: [Movie]

    typealias ModelType = MoviesResult
    static func parse(json: JSON) -> MoviesResult {
        MoviesResult(
            totalResult: json["totalResults"].intValue,
            movies: json["Search"].arrayValue.map { Movie.parse(json: $0) }
        )
    }
}
