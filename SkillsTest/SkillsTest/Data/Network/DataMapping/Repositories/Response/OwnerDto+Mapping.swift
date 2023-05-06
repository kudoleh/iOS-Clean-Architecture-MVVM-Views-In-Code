import Foundation

extension OwnerDto {
    func toDomain() -> Owner {
        return .init(
            id: id,
            name: login,
            avatarUrl: avatarUrl
        )
    }
}
