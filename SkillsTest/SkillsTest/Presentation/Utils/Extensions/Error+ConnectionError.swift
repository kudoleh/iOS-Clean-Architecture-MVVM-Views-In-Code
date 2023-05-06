import Foundation

extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? DataTransferError,
              case let .networkFailure(networkError) = error,
              case .notConnected = networkError else {
            return false
        }
        return true
    }
}
