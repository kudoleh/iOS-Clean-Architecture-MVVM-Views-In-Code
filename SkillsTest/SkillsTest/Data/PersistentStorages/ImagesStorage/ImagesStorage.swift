import Foundation

protocol ImagesStorage {
    func getImageData(
        for urlPath: String,
        completion: @escaping (Result<Data?, Error>) -> Void
    )
    func save(imageData: Data, for urlPath: String)
}
