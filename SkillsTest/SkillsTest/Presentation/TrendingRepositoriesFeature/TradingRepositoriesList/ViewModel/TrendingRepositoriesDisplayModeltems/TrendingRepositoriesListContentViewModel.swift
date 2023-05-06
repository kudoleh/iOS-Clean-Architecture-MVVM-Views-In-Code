import Foundation

enum TrendingRepositoriesListContentViewModel: Hashable {
    case items([TrendingRepositoriesListItemViewModel])
    case emptyData
    case loading
}
