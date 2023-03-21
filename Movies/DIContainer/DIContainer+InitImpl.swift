import Swinject

extension DIContainer {
    func initImpl() {
        // MARK: - Repository injection impl
        container.register(MoviesRepository.self) { _ in MoviesServices() }
    }
}
