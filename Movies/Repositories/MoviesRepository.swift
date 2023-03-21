import Foundation
import RxSwift

struct GetMovieListRequestInput {
    let apiKey: String
    let search: String
    let type: String

    var params: [String: Any] {
        [
            "apiKey": apiKey,
            "s": search,
            "type": type,
        ]
    }
}

protocol MoviesRepository {
    func getMovieList(
        bag: DisposeBag,
        input: GetMovieListRequestInput,
        loadMoreRequest: LoadMoreRequest,
        _ resultHandler: @escaping ResultHandler<MoviesResult>
    )
}
