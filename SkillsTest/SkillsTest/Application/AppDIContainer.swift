import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: appConfiguration.apiBaseURL
        )
        
        let apiDataNetwork = DefaultNetworkService(
            config: config,
            logger: DefaultNetworkLogger(
                shouldLogRequests: appConfiguration.shouldLogNetworkRequests
            )
        )
        return DefaultDataTransferService(
            with: apiDataNetwork
        )
    }()
    
    lazy var imagesDataTransferService: DataTransferService = {
        let imagesDataNetwork = DefaultNetworkService(
            logger: DefaultNetworkLogger(
                shouldLogRequests: appConfiguration.shouldLogNetworkRequests
            )
        )
        return DefaultDataTransferService(with: imagesDataNetwork)
    }()
    
    // MARK: - DIContainers of features
    func makeTrendingRepositoriesFeatureDIContainer() -> TrendingRepositoriesFeatureDIContainer {
        let dependencies = TrendingRepositoriesFeatureDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            imagesDataTransferService: imagesDataTransferService,
            appConfiguration: appConfiguration
        )
        return TrendingRepositoriesFeatureDIContainer(dependencies: dependencies)
    }
}
