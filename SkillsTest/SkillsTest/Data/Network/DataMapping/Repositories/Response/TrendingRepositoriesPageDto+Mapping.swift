import Foundation

extension TrendingRepositoriesPageDto {
    func toDomain() -> TrendingRepositoriesPage {
        .init(
            items: items.map { $0.toDomain() }
        )
    }
}
