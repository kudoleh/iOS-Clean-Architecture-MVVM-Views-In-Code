import Foundation

extension RepositoryDto {
    func toDomain() -> Repository {
        .init(
            id: id,
            owner: owner.toDomain(),
            name: name,
            description: description,
            stargazersCount: stargazersCount,
            language: language
        )
    }
}
