import Foundation

struct TrendingRepositoriesRequestQuery: Encodable {
    
    private enum CodingKeys : String, CodingKey {
        case query = "q"
    }
    
    let query = "language=+sort:stars"
}
