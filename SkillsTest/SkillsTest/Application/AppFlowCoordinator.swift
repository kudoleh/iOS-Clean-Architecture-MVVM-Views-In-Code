import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let trendingTrendingRepositoriesFeatureDIContainer = appDIContainer.makeTrendingRepositoriesFeatureDIContainer()
        let flow = trendingTrendingRepositoriesFeatureDIContainer.makeTrendingRepositoriesFlowCoordinator(
            navigationController: navigationController
        )
        flow.start()
    }
}
