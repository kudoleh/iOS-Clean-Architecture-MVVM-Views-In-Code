import XCTest
@testable import SkillsTest

class FetchTrendingRepositoriesUseCaseTests: XCTestCase {

    static let trendingRepositoriesPage = TrendingRepositoriesPage(
        items: [
            .stub(name: "Repository1"),
            .stub(name: "Repository2"),
        ]
    )

    enum TrendingRepositoriesRepositorySuccessTestError: Error {
        case failedFetching
    }

    final class TrendingRepositoriesRepositoryMock: TrendingRepositoriesRepository {

        typealias FetchTrendingRepositoriesListBlock = (
            (TrendingRepositoriesPage) -> Void,
            (Result<TrendingRepositoriesPage, Error>) -> Void
        ) -> Void

        lazy var _fetchTrendingRepositoriesList: FetchTrendingRepositoriesListBlock = { _, _ in
            XCTFail("not implemented")
        }
        
        func fetchTrendingRepositoriesList(
            cached: @escaping (TrendingRepositoriesPage) -> Void,
            completion: @escaping (Result<TrendingRepositoriesPage, Error>) -> Void
        ) -> Cancellable? {
            _fetchTrendingRepositoriesList(cached, completion)
            return nil
        }
    }

    func testFetchTrendingRepositoriesUseCase_whenRepositorySuccessfullyFetches_thenUseCaseExecutesWithSuccess() {
        // given
        var completionCalls = 0
        var cachedCompletionCalls = 0
        let trendingRepositoriesRepositoryMock = TrendingRepositoriesRepositoryMock()
        
        let cachedPage = TrendingRepositoriesPage(
            items: [
                .stub(name: "CachedRepository1"),
                .stub(name: "CachedRepository2"),
            ]
        )
        
        trendingRepositoriesRepositoryMock._fetchTrendingRepositoriesList = { cached, completion in
            cached(cachedPage)
            completion(
                .success(FetchTrendingRepositoriesUseCaseTests.trendingRepositoriesPage)
            )
            completionCalls += 1
        }
        let useCase = DefaultFetchTrendingRepositoriesUseCase(
            trendingRepositoriesRepository: trendingRepositoriesRepositoryMock
        )
        
        // when
        _ = useCase.fetch(
            cached: { page in
                XCTAssertEqual(page, cachedPage)
                cachedCompletionCalls += 1
            },
            completion: { result in
                switch result {
                case .success(let page):
                    XCTAssertEqual(
                        FetchTrendingRepositoriesUseCaseTests.trendingRepositoriesPage,
                        page
                    )
                    completionCalls += 1
                case .failure:
                    XCTFail("Should not fail")
                }
            })
        // then
        XCTAssertEqual(completionCalls, 2)
        XCTAssertEqual(cachedCompletionCalls, 1)
    }

    func testFetchTrendingRepositoriesUseCase_whenRepositoryFailsFetching_thenUseCaseExecutesWithFailure() {
        // given
        var completionCalls = 0
        let trendingRepositoriesRepositoryMock = TrendingRepositoriesRepositoryMock()

        trendingRepositoriesRepositoryMock._fetchTrendingRepositoriesList = { _, completion in
            completionCalls += 1
        }
        let useCase = DefaultFetchTrendingRepositoriesUseCase(
            trendingRepositoriesRepository: trendingRepositoriesRepositoryMock
        )

        // when
        _ = useCase.fetch(
            cached: { _ in },
            completion: { _ in
                completionCalls += 1
            }
        )
        // then
        XCTAssertEqual(completionCalls, 1)

        // Test for memory leaks
        addTeardownBlock { [weak useCase] in
            XCTAssertNil(useCase)
        }
    }
}
