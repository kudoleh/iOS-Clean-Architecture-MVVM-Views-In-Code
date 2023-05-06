import XCTest
@testable import SkillsTest

struct NetworkSessionManagerMock: NetworkSessionManager {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(
        _ request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable {
        completion(data, response, error)
        return NetworkCancellableMock()
    }
}

struct NetworkCancellableMock: NetworkCancellable {
    func cancel() {}
}
