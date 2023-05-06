import Foundation
import CoreData

final class CoreDataTrendingRepositoriesStorage {
    
    struct Config {
        let maxAliveTimeInSeconds: TimeInterval
    }

    private let coreDataStorage: CoreDataStorage
    private let currentTime: () -> Date
    private let config: Config

    init(
        coreDataStorage: CoreDataStorage = .shared,
        currentTime: @escaping () -> Date,
        config: Config
    ) {
        self.coreDataStorage = coreDataStorage
        self.currentTime = currentTime
        self.config = config
    }

    // MARK: - Private

    private func fetchTrendingRepositoriesPageRequest() -> NSFetchRequest<TrendingRepositoriesPageEntity> {

        let request: NSFetchRequest = TrendingRepositoriesPageEntity.fetchRequest()

        return request
    }

    private func deleteTrendingRepositoriesPageDto(
        in context: NSManagedObjectContext
    ) {
        let request = fetchTrendingRepositoriesPageRequest()

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension CoreDataTrendingRepositoriesStorage: TrendingRepositoriesStorage {

    func getTrendingRepositoriesPageDto(
        completion: @escaping (Result<TrendingRepositoriesStorageItem?, Error>) -> Void
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest: NSFetchRequest = self.fetchTrendingRepositoriesPageRequest()
                let entity = try context.fetch(fetchRequest).first
                let entityDto = try entity?.toDto()

                if let entity, let savedAt = entity.savedAt,
                   self.currentTime().timeIntervalSince(savedAt) > self.config.maxAliveTimeInSeconds {
                    completion(.success(entityDto.map { .outdated($0) }))
                } else {
                    completion(.success(entityDto.map { .upToDate($0) }))
                }
                
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }

    func save(trendingRepositoriesPageDto: TrendingRepositoriesPageDto) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteTrendingRepositoriesPageDto(in: context)

                let entity = trendingRepositoriesPageDto.toEntity(in: context)
                entity.savedAt = self.currentTime()

                try context.save()
            } catch {
                assertionFailure("CoreDataUsersStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
