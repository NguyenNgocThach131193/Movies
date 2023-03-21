import Swinject

extension DIContainer {
    func getMoviesRepository() -> MoviesRepository {
        threadSafeContainer.resolve(MoviesRepository.self)!
    }
}
