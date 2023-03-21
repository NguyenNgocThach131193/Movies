import Foundation

public struct LoadMoreRequest {
    private struct Constant {
        static let startPage = 1
    }

    var page: Int
    var isLoading: Bool
    var isLastPage: Bool

    public var dictionary: [String: Any] {
        var dict = [String: Any]()
        dict["page"] = page
        return dict
    }

    var isFirstPage: Bool {
        return page == 1
    }

    static var empty: LoadMoreRequest {
        LoadMoreRequest(
            page: Constant.startPage,
            isLoading: false,
            isLastPage: false
        )
    }

    mutating func increasePage() {
        self.page += 1
    }

    mutating func resetPage() {
        self.page = Constant.startPage
        self.isLoading = false
        self.isLastPage = false
    }

    mutating func turnOnLoadMore() {
        self.isLoading = true
    }

    mutating func turnOffLoadingMore() {
        self.isLoading = false
    }

    mutating func updateIsLastPage() {
        self.isLastPage = true
    }
}
