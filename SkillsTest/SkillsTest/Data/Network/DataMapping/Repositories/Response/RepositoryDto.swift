import Foundation

struct RepositoryDto: Decodable {
    let id: Int
    let owner: OwnerDto
    let name: String
    let description: String
    let stargazersCount: Int
    let language: String?
}
