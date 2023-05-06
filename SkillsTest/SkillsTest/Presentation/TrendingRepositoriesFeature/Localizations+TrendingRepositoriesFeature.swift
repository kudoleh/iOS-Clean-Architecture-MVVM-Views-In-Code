import Foundation

enum Localizations { }

extension Localizations {
    enum TrendingRepositoriesFeature {
        enum TrendingRepositoriesList { }
    }
}

extension Localizations.TrendingRepositoriesFeature.TrendingRepositoriesList {
    enum ListScreen {
        static let title = "Trending"
    }
    enum EmptyState {
        static let emptyDataPullToRefresh = "No data\nPlease pull to refresh"
    }
    enum Errors {
        static let failedLoadingRepositoriesTitle = "Something went wrong.."
    }
}

extension Localizations {
    enum Common {
        enum Errors {
            static let noInternetConnection = "No Internet connection"
            static let errorTitle = "Error"
            static let okButtonTitle = "OK"
        }
    }
}
