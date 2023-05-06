import Foundation
import CoreData

enum MappingUsersPageEntityError: Error {
    case incorrectRepositoryEntity
}

// MARK: - Mapping To Dto

extension TrendingRepositoriesPageEntity {
    func toDto() throws -> TrendingRepositoriesPageDto {
        return .init(
            items: try items?
                .array
                .map {
                    guard let entity = $0 as? RepositoryEntity else {
                        throw MappingUsersPageEntityError.incorrectRepositoryEntity
                    }
                    return try entity.toDto()
                } ?? []
        )
    }
}

// MARK: - Mapping To CoreData Entity

extension TrendingRepositoriesPageDto {
    func toEntity(
        in context: NSManagedObjectContext
    ) -> TrendingRepositoriesPageEntity {
        let entity: TrendingRepositoriesPageEntity = .init(context: context)
        entity.items = NSOrderedSet(
            array: items.map { $0.toEntity(in: context) }
        )
        return entity
    }
}
