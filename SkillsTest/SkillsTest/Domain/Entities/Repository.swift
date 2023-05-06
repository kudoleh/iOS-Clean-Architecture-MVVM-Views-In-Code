import Foundation

struct Repository: Equatable {
    let id: Int
    let owner: Owner
    let name: String
    let description: String
    let stargazersCount: Int
    let language: String?
}
