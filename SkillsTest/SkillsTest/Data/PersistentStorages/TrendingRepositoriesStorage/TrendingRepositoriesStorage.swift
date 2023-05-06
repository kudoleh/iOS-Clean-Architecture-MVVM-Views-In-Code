import Foundation

enum TrendingRepositoriesStorageItem {
    case upToDate(TrendingRepositoriesPageDto)
    case outdated(TrendingRepositoriesPageDto)
}

protocol TrendingRepositoriesStorage {
    func getTrendingRepositoriesPageDto(
        completion: @escaping (Result<TrendingRepositoriesStorageItem?, Error>) -> Void
    )
    func save(trendingRepositoriesPageDto: TrendingRepositoriesPageDto)
}
