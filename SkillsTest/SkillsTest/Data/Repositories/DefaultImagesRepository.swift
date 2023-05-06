import Foundation

enum ImagesRepositoryError: Error {
    case invalidPathUrl
}

final class DefaultImagesRepository {
    
    private let dataTransferService: DataTransferService
    private let imagesCache: ImagesStorage
    private let backgroundQueue: DataTransferDispatchQueue

    init(
        dataTransferService: DataTransferService,
        imagesCache: ImagesStorage,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.imagesCache = imagesCache
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultImagesRepository: ImagesRepository {
    
    func fetchImage(
        with imagePath: String,
        size: Int,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable? {
        
        let task = RepositoryTask()
        
        let endpoint = APIEndpoints.getImage(
            path: imagePath,
            requestQuery: ImagesRequestQuery(size: size)
        )
        
        guard let pathUrlWithPath = try? dataTransferService.url(for: endpoint).absoluteString else {
            completion(.failure(ImagesRepositoryError.invalidPathUrl))
            return task
        }

        imagesCache.getImageData(
            for: pathUrlWithPath
        ) { [dataTransferService, backgroundQueue, imagesCache] result in

            if case let .success(imageData?) = result {
                completion(.success(imageData))
                return
            }
            guard !task.isCancelled else { return }

            task.networkTask = dataTransferService.request(
                with: endpoint,
                on: backgroundQueue
            ) { [imagesCache] (result: Result<Data, DataTransferError>) in
                if case let .success(imageData) = result {
                    imagesCache.save(imageData: imageData, for: pathUrlWithPath)
                }
                let result = result.mapError { $0 as Error }
                completion(result)
            }
        }
        return task
    }
}
