import Foundation

protocol TrendingRepositoriesRepository {
    @discardableResult
    func fetchTrendingRepositoriesList(
        cached: @escaping (TrendingRepositoriesPage) -> Void,
        completion: @escaping (Result<TrendingRepositoriesPage, Error>) -> Void
    ) -> Cancellable?
}
