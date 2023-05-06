import XCTest
@testable import SkillsTest

extension Repository {
    static func stub(
        id: Int = 1,
        owner: Owner = .stub(),
        name: String = "RepositoryName",
        description: String = "Description",
        stargazersCount: Int = 0,
        language: String? = nil
    ) -> Self {
        .init(
            id: id,
            owner: owner,
            name: name,
            description: description,
            stargazersCount: stargazersCount,
            language: language
        )
    }
}

extension Owner {
    static func stub(
        id: Int = 1,
        name: String = "OwnerName",
        avatarUrl: String = "http://mock.endpoint.com"
    ) -> Self {
        .init(
            id: id,
            name: "OwnerName",
            avatarUrl: avatarUrl
        )
    }
}
