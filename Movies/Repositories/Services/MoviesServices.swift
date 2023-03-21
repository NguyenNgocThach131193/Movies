import RxSwift
import SwiftyJSON
import Alamofire

private struct MoviesServicesURLs {
    static let movies = Enpoint.APIEndPoint + "/"
}

class MoviesServices: RxBaseService { }

extension MoviesServices: MoviesRepository {
    func getMovieList(
        bag: DisposeBag,
        input: GetMovieListRequestInput,
        loadMoreRequest: LoadMoreRequest,
        _ resultHandler: @escaping ResultHandler<MoviesResult>
    ) {
        let url = MoviesServicesURLs.movies
        var params = loadMoreRequest.dictionary
        params.merge(input.params, uniquingKeysWith: { (current, _) in current })
        requestJSON(
            url: url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default
        )
        .observe(on: AppFlowManager.shared.backgroundWorkScheduler)
        .subscribe(onNext: { json in
            resultHandler(.success(.parse(json: json)))
        }, onError: { error in
            resultHandler(.failure(error))
        }).disposed(by: bag)
    }
}
