import Foundation
import CoreData

enum MappingRepositoryEntityError: Error {
    case missingOwnerData
    case missingData
}

// MARK: - Mapping To Dto

extension RepositoryEntity {
    func toDto() throws -> RepositoryDto {
        guard let ownerDto = try owner?.toDto() else {
            throw MappingRepositoryEntityError.missingOwnerData
        }
        guard let name, let description = descriptionText
        else {
            throw MappingRepositoryEntityError.missingData
        }
        return .init(
            id: Int(id),
            owner: ownerDto,
            name: name,
            description: description,
            stargazersCount: Int(stargazersCount),
            language: language
        )
    }
}

// MARK: - Mapping To CoreData Entity

extension RepositoryDto {
    func toEntity(in context: NSManagedObjectContext) -> RepositoryEntity {

        let entity: RepositoryEntity = .init(context: context)
        entity.id = Int64(id)
        entity.owner = owner.toEntity(in: context)
        entity.name = name
        entity.descriptionText = description
        entity.stargazersCount = Int64(stargazersCount)
        entity.language = language

        return entity
    }
}
