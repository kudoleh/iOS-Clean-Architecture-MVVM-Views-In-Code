import Foundation
import CoreData

final class CoreDataImagesStorage {
    
    /// Using LRU logic
    static let maxSizeInBytes = 200 * 1000000 // 200 MB

    private let coreDataStorage: CoreDataStorage
    private let currentTime: () -> Date
    
    init(
        coreDataStorage: CoreDataStorage = .shared,
        currentTime: @escaping () -> Date
    ) {
        self.coreDataStorage = coreDataStorage
        self.currentTime = currentTime
    }

    // MARK: - Private

    private func fetchRequest(
        for pathUrl: String
    ) -> NSFetchRequest<ImageEntity> {

        let request: NSFetchRequest = ImageEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(ImageEntity.pathUrl), pathUrl
        )
        return request
    }

    private func deleteImage(
        for urlPath: String,
        in context: NSManagedObjectContext
    ) {
        let request = fetchRequest(for: urlPath)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
    
    static func removeLeastRecentlyUsedImages() {
        CoreDataStorage.shared.performBackgroundTask { context in
            do {
                let fetchRequest: NSFetchRequest = ImageEntity.fetchRequest()
                
                let sort = NSSortDescriptor(
                    key: #keyPath(ImageEntity.lastUsedAt),
                    ascending: false
                )
                fetchRequest.sortDescriptors = [sort]
                
                let entities = try context.fetch(fetchRequest)
                
                var totalSizeUsed = 0
                entities.forEach { entity in
                    totalSizeUsed += (entity.data as? NSData)?.length ?? 0
                    print(totalSizeUsed)
                    if totalSizeUsed > self.maxSizeInBytes {
                        context.delete(entity)
                    }
                }

                try context.save()
            } catch {
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}

extension CoreDataImagesStorage: ImagesStorage {

    func getImageData(
        for urlPath: String,
        completion: @escaping (Result<Data?, Error>) -> Void
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: urlPath)
                let entity = try context.fetch(fetchRequest).first
                
                entity?.lastUsedAt = self.currentTime()
                
                try context.save()

                completion(.success(entity?.data))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func save(imageData: Data, for urlPath: String) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteImage(for: urlPath, in: context)
                
                let entity: ImageEntity = .init(context: context)
                entity.data = imageData
                entity.pathUrl = urlPath
                entity.lastUsedAt = self.currentTime()
                
                try context.save()
            } catch {
                assertionFailure("CoreDataUsersStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}

