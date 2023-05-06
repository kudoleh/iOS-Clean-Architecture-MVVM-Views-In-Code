import Foundation

protocol FetchTrendingRepositoriesUseCase {
    func fetch(
        cached: @escaping (TrendingRepositoriesPage) -> Void,
        completion: @escaping (Result<TrendingRepositoriesPage, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultFetchTrendingRepositoriesUseCase: FetchTrendingRepositoriesUseCase {

    private let trendingRepositoriesRepository: TrendingRepositoriesRepository

    init(
        trendingRepositoriesRepository: TrendingRepositoriesRepository
    ) {
        self.trendingRepositoriesRepository = trendingRepositoriesRepository
    }

    func fetch(
        cached: @escaping (TrendingRepositoriesPage) -> Void,
        completion: @escaping (Result<TrendingRepositoriesPage, Error>) -> Void
    ) -> Cancellable? {

        trendingRepositoriesRepository.fetchTrendingRepositoriesList(
            cached: cached,
            completion: completion
        )
    }
}
