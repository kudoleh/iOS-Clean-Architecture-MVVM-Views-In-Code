import Foundation

final class DefaultTrendingRepositoriesRepository {

    private let dataTransferService: DataTransferService
    private let cache: TrendingRepositoriesStorage

    init(
        dataTransferService: DataTransferService,
        cache: TrendingRepositoriesStorage
    ) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

extension DefaultTrendingRepositoriesRepository: TrendingRepositoriesRepository {

    func fetchTrendingRepositoriesList(
        cached: @escaping (TrendingRepositoriesPage) -> Void,
        completion: @escaping (Result<TrendingRepositoriesPage, Error>) -> Void
    ) -> Cancellable? {

        let task = RepositoryTask()

        cache.getTrendingRepositoriesPageDto { [cache, dataTransferService] cacheResult in

            let shouldFetchData: Bool
            if case let .success(value) = cacheResult {
                switch value {
                case .upToDate(let pageDto):
                    cached(pageDto.toDomain())
                    completion(.success(pageDto.toDomain()))
                    shouldFetchData = false
                case .outdated(let pageDto):
                    cached(pageDto.toDomain())
                    shouldFetchData = true
                case .none:
                    shouldFetchData = true
                }
            } else {
                shouldFetchData = true
            }
            
            /// fetch new data if cache is outdated or nil
            guard shouldFetchData,
                  !task.isCancelled else { return }
            
            let endpoint = APIEndpoints.getTrendingRepositories(
                requestQuery: TrendingRepositoriesRequestQuery()
            )
            task.networkTask = dataTransferService.request(
                with: endpoint
            ) { result in
                switch result {
                case .success(let trendingRepositoriesPageDto):
                    cache.save(trendingRepositoriesPageDto: trendingRepositoriesPageDto)
                    let page = trendingRepositoriesPageDto.toDomain()
                    completion(.success(page))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        return task
    }
}
