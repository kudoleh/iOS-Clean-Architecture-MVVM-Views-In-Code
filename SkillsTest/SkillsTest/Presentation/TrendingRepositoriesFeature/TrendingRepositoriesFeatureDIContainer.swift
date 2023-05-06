import UIKit
import SwiftUI

final class TrendingRepositoriesFeatureDIContainer: TrendingRepositoriesFlowCoordinatorDependencies {

    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imagesDataTransferService: DataTransferService
        let appConfiguration: AppConfiguration
    }

    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    lazy var trendingRepositoriesCache: TrendingRepositoriesStorage = CoreDataTrendingRepositoriesStorage(
        currentTime: { Date() },
        config: .init(
            maxAliveTimeInSeconds: dependencies
                .appConfiguration
                .trendingRepositoriesCacheMaxAliveTimeInSeconds
        )
    )
    lazy var imagesCache: ImagesStorage = CoreDataImagesStorage(
        currentTime: { Date() }
    )

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Use Cases
    func makeFetchTrendingRepositoriesUseCase() -> FetchTrendingRepositoriesUseCase {
        DefaultFetchTrendingRepositoriesUseCase(
            trendingRepositoriesRepository: makeTrendingRepositoriesRepository()
        )
    }

    // MARK: - Repositories
    func makeTrendingRepositoriesRepository() -> TrendingRepositoriesRepository {
        DefaultTrendingRepositoriesRepository(
            dataTransferService: dependencies.apiDataTransferService,
            cache: trendingRepositoriesCache
        )
    }
    
    func makeImagesRepository() -> ImagesRepository {
        DefaultImagesRepository(
            dataTransferService: dependencies.imagesDataTransferService,
            imagesCache: imagesCache
        )
    }

    // MARK: - Trending Repositories List
    // MARK: - TrendingRepositoriesFlowCoordinatorDependencies
    func makeTrendingRepositoriesListViewController() -> TrendingRepositoriesListViewController {
        TrendingRepositoriesListViewController(
            viewModel: makeTrendingRepositoriesListViewModel(),
            imagesRepository: makeImagesRepository()
        )
    }
    
    func makeTrendingRepositoriesListViewModel() -> TrendingRepositoriesListViewModel {
        DefaultTrendingRepositoriesListViewModel(
            fetchTrendingRepositoriesUseCase: makeFetchTrendingRepositoriesUseCase(),
            mainQueue: DispatchQueue.main
        )
    }

    // MARK: - Flow Coordinators
    func makeTrendingRepositoriesFlowCoordinator(navigationController: UINavigationController) -> TrendingRepositoriesFlowCoordinator {
        TrendingRepositoriesFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
