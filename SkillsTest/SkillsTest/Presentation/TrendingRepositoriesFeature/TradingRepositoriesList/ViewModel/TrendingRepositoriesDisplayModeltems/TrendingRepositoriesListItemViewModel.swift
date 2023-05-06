import Foundation
import UIKit

struct TrendingRepositoriesListItemViewModel: Hashable {
    struct RepositoryOwnerItemViewModel: Hashable {
        let name: String
        let avatarUrl: String
    }
    struct RepositoryItemViewModel: Hashable {
        let id: Int
        let owner: RepositoryOwnerItemViewModel
        let name: String
        let description: String
        let stargazersCountFormatted: String
        let language: String?
        let languageColor: UIColor?
    }
    let repository: RepositoryItemViewModel
    var isExpanded: Bool = false
}

extension TrendingRepositoriesListItemViewModel {

    init(repository: Repository) {
        self.repository = .init(
            id: repository.id,
            owner: .init(
                name: repository.owner.name,
                avatarUrl: repository.owner.avatarUrl
            ),
            name: repository.name,
            description: repository.description,
            stargazersCountFormatted: repository.stargazersCount.formatLongNumber(),
            language: repository.language,
            languageColor: repository.languageColor
        )
    }
}

private extension Repository {
    var languageColor: UIColor? {
        guard let language else { return nil }
        switch language {
        case "Go":
            return .systemTeal
        case "TypeScript":
            return .systemOrange
        case "Python":
            return .systemBlue
        default:
            return .systemBlue
        }
    }
}

private extension Int {
    func formatLongNumber() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)b"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)m"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)k"

        case 0...:
            return "\(self)"

        default:
            return "\(sign)\(self)"
        }
    }
}

private extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self
        let truncated = Double(Int(newDecimal))
        let originalDecimal = truncated / multiplier
        return originalDecimal
    }
}
