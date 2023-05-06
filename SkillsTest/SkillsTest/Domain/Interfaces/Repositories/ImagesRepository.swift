import Foundation

protocol ImagesRepository {
    func fetchImage(
        with imagePath: String,
        size: Int,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable?
}
