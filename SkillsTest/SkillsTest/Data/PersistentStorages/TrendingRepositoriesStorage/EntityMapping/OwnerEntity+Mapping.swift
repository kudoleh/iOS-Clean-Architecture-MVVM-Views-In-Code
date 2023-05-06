import Foundation
import CoreData

enum MappingOwnerEntityError: Error {
    case missingData
}

// MARK: - Mapping To Dto

extension OwnerEntity {
    func toDto() throws -> OwnerDto {
        guard let login = login, let avatarUrl = avatarUrl else {
            throw MappingOwnerEntityError.missingData
        }
        return .init(
            id: Int(id),
            login: login,
            avatarUrl: avatarUrl
        )
    }
}

// MARK: - Mapping To CoreData Entity

extension OwnerDto {
    func toEntity(in context: NSManagedObjectContext) -> OwnerEntity {
        let entity: OwnerEntity = .init(context: context)
        entity.id = Int64(id)
        entity.login = login
        entity.avatarUrl = avatarUrl

        return entity
    }
}
