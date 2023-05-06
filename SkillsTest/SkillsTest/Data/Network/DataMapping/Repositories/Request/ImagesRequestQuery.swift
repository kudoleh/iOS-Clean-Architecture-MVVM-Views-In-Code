import Foundation

struct ImagesRequestQuery: Encodable {
    
    private enum CodingKeys : String, CodingKey {
        case size = "s"
    }
    
    let size: Int
}
