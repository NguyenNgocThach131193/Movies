import Swinject

extension DIContainer {
    func setUserRepository(_ repository: MoviesRepository) {
        container.register(MoviesRepository.self) { _ in repository }
    }
}
