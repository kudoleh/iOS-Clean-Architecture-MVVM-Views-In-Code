import UIKit

protocol TrendingRepositoriesFlowCoordinatorDependencies {
    func makeTrendingRepositoriesListViewController() -> TrendingRepositoriesListViewController
}

final class TrendingRepositoriesFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: TrendingRepositoriesFlowCoordinatorDependencies

    init(
        navigationController: UINavigationController,
        dependencies: TrendingRepositoriesFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewController = dependencies.makeTrendingRepositoriesListViewController()
        navigationController?.pushViewController(viewController, animated: false)
    }
}
