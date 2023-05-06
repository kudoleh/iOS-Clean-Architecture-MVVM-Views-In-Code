import Foundation

extension Error {
    var isCancelError: Bool {
        guard let error = self as? DataTransferError,
              case let DataTransferError.networkFailure(networkError) = error,
              case .cancelled = networkError else {
            return false
        }
        return true
    }
}
