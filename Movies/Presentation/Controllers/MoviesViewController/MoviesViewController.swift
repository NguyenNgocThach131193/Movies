import UIKit
import RxSwift
import SnapKit

class MoviesViewController: UIViewController {
    struct Constant {
        static let imageHeight: CGFloat = (ScreenSize.width - 35) / 2
    }

    private lazy var collectionViewLayout: PinterestLayout = {
        let layout = PinterestLayout()
        layout.numberOfColumns = 2
        layout.delegate = self
        layout.cellPadding = 3
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.registerNib(MovieCell.self)
        collectionView.contentInset = .init(top: 10, left: 13, bottom: 0, right: 13)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        return collectionView
    }()

    private let refreshControl = UIRefreshControl()

    private var movies: [Movie] = []
    private var loadmore: LoadMoreRequest = .empty
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Private func
private extension MoviesViewController {
    func setupViews() {
        view.backgroundColor = .white
        title = "Movies"

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        refreshControl.on(.valueChanged) { [weak self] sender, forEvent in
            guard let self = self else {
                return
            }
            self.loadmore.resetPage()
            self.getMovieList()
        }

        getMovieList()
    }

    private func updateCollectionView() {
        if movies.isEmpty {
            collectionView.setEmptyMessage("UICollectionView.EmptyLabel.Text".localized())
        } else {
            collectionView.restore()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(aClass: MovieCell.self, for: indexPath)
        let movie = movies[indexPath.row]
        cell.setup(title: movie.title, year: movie.year, poster: movie.poster)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y > 0 else { return }
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            let shouldLoadMore = !loadmore.isLoading && !loadmore.isLastPage
            guard scrollView.contentSize.height > (scrollView.bounds.height - 100) && shouldLoadMore else { return }
            loadMoreData()
        }
    }
}

// MARK: - PinterestLayoutDelegate
extension MoviesViewController: PinterestLayoutDelegate {
    func collectionView(
        collectionView: UICollectionView,
        heightForImageAtIndexPath indexPath: IndexPath,
        withWidth: CGFloat
    ) -> CGFloat {
        Constant.imageHeight
    }
}

// MARK: - APIs
private extension MoviesViewController {
    func getMovieList() {
        let service = DIContainer.shared.getMoviesRepository()
        loadmore.turnOnLoadMore()
        service.getMovieList(
            bag: disposeBag,
            input: .init(
                apiKey: "b9bd48a6",
                search: "Marvel",
                type: "movie"
            ),
            loadMoreRequest: loadmore
        ) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let response):
                self.handleResponse(response)
            case .failure(let error):
                Logger.error(message: error)
                self.handleError(error)
            }
        }
    }

    func handleResponse(_ response: MoviesResult) {
        if loadmore.isFirstPage {
            movies.removeAll()
        }
        loadmore.increasePage()
        movies += response.movies
        if movies.isEmpty {
            loadmore.updateIsLastPage()
        }
        loadmore.turnOffLoadingMore()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.updateCollectionView()
            self.refreshControl.endRefreshing()
        }
    }

    func handleError(_ error: Error) {
        loadmore.turnOffLoadingMore()
        DispatchQueue.main.async {
            self.updateCollectionView()
            self.refreshControl.endRefreshing()
        }
    }

    func loadMoreData() {
        getMovieList()
    }
}
