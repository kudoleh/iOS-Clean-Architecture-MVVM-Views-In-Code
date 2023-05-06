import XCTest
@testable import SkillsTest

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL? = URL(string: "https://mock.test.com")
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}
