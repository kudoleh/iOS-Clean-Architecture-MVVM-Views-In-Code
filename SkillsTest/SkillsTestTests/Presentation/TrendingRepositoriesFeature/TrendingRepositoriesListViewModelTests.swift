import XCTest
@testable import SkillsTest

class TrendingRepositoriesListViewModelTests: XCTestCase {

    private enum FetchTrendingRepositoriesUseCaseError: Error {
        case someError
    }

    static let trendingRepositoriesPage = TrendingRepositoriesPage(
        items: [
            .stub(name: "Repository1"),
            .stub(name: "Repository2"),
        ]
    )

    final class FetchTrendingRepositoriesUseCaseMock: FetchTrendingRepositoriesUseCase {
        typealias FetchBlock = (
            (TrendingRepositoriesPage) -> Void,
            (Result<TrendingRepositoriesPage, Error>) -> Void
        ) -> Void

        lazy var _fetch: FetchBlock = { _, _ in
            XCTFail("not implemented")
        }

        func fetch(
            cached: @escaping (TrendingRepositoriesPage) -> Void,
            completion: @escaping (Result<TrendingRepositoriesPage, Error>) -> Void
        ) -> Cancellable? {
            _fetch(cached, completion)
            return nil
        }
    }

    func test_whenFetchTrendingRepositoriesUseCaseRetrievesEmptyPage_thenViewModelIsEmpty() {
        // given
        let fetchTrendingRepositoriesUseCaseMock = FetchTrendingRepositoriesUseCaseMock()
        var fetchCompletionCalls = 0
        fetchTrendingRepositoriesUseCaseMock._fetch = { _, completion in
            completion(.success(TrendingRepositoriesPage.init(items: [])))
            fetchCompletionCalls += 1
        }
        let viewModel = DefaultTrendingRepositoriesListViewModel.make(
            fetchTrendingRepositoriesUseCase: fetchTrendingRepositoriesUseCaseMock
        )
        // when
        viewModel.viewDidLoad()

        // then
        XCTAssertEqual(fetchCompletionCalls, 1)
        XCTAssert(viewModel.content.value == .emptyData)
        XCTAssertEqual(viewModel.items.count, 0)
    }

    func test_whenFetchTrendingRepositoriesUseCaseRetrievesRepositories_thenViewModelContainsTwoItems() {
        // given
        let fetchTrendingRepositoriesUseCaseMock = FetchTrendingRepositoriesUseCaseMock()
        var fetchCompletionCalls = 0
        fetchTrendingRepositoriesUseCaseMock._fetch = { _, completion in
            completion(.success(TrendingRepositoriesListViewModelTests.trendingRepositoriesPage))
            fetchCompletionCalls += 1
        }
        let viewModel = DefaultTrendingRepositoriesListViewModel.make(
            fetchTrendingRepositoriesUseCase: fetchTrendingRepositoriesUseCaseMock
        )
        // when
        viewModel.viewDidLoad()

        // then
        let expectedItems = TrendingRepositoriesListViewModelTests
            .trendingRepositoriesPage
            .items
            .map { TrendingRepositoriesListItemViewModel(repository: $0) }
        XCTAssertEqual(viewModel.items, expectedItems)
        XCTAssertEqual(fetchCompletionCalls, 1)
    }

    func test_whenFetchTrendingRepositoriesUseCaseReturnsError_thenViewModelContainsError() {
        // given
        let fetchTrendingRepositoriesUseCaseMock = FetchTrendingRepositoriesUseCaseMock()
        var fetchCompletionCalls = 0
        fetchTrendingRepositoriesUseCaseMock._fetch = { _, completion in
            completion(.failure(FetchTrendingRepositoriesUseCaseError.someError))
            fetchCompletionCalls += 1
        }
        let viewModel = DefaultTrendingRepositoriesListViewModel.make(
            fetchTrendingRepositoriesUseCase: fetchTrendingRepositoriesUseCaseMock
        )
        // when
        viewModel.viewDidLoad()

        // then
        XCTAssertEqual(fetchCompletionCalls, 1)
        XCTAssertNotNil(viewModel.error)
    }
    
    func test_whenSelectTrendingRepository_thenViewModelShouldExpandThisRepository() {
        // given
        let fetchTrendingRepositoriesUseCaseMock = FetchTrendingRepositoriesUseCaseMock()
        var fetchCompletionCalls = 0
        fetchTrendingRepositoriesUseCaseMock._fetch = { _, completion in
            completion(.success(TrendingRepositoriesListViewModelTests.trendingRepositoriesPage))
            fetchCompletionCalls += 1
        }
        let viewModel = DefaultTrendingRepositoriesListViewModel.make(
            fetchTrendingRepositoriesUseCase: fetchTrendingRepositoriesUseCaseMock
        )
        // when
        viewModel.viewDidLoad()
        
        let allExpandedBeforeSelection = viewModel.items.allSatisfy { model in
            !model.isExpanded
        }
        
        viewModel.viewDidSelectItem(at: 1)
        let itemIsExpandedAfterFirstSelection = viewModel.items[1].isExpanded
        
        viewModel.viewDidSelectItem(at: 1)
        let itemIsExpandedAfterSecondSelection = viewModel.items[1].isExpanded

        // then
        XCTAssertTrue(allExpandedBeforeSelection)
        XCTAssertTrue(itemIsExpandedAfterFirstSelection)
        XCTAssertFalse(itemIsExpandedAfterSecondSelection)
    }
    
    func test_whenFetchRepositoriesUseCaseReturnsError_thenViewModelShowsCachedData() {
        // given
        let fetchTrendingRepositoriesUseCaseMock = FetchTrendingRepositoriesUseCaseMock()
        var fetchCompletionCalls = 0
        fetchTrendingRepositoriesUseCaseMock._fetch = { cached, completion in
            cached(TrendingRepositoriesListViewModelTests.trendingRepositoriesPage)
            completion(.failure(FetchTrendingRepositoriesUseCaseError.someError))
            fetchCompletionCalls += 1
        }

        // when
        let viewModel = DefaultTrendingRepositoriesListViewModel.make(
            fetchTrendingRepositoriesUseCase: fetchTrendingRepositoriesUseCaseMock
        )
        // when
        viewModel.viewDidLoad()

        // then
        let expectedItems = TrendingRepositoriesListViewModelTests
            .trendingRepositoriesPage
            .items
            .map { TrendingRepositoriesListItemViewModel(repository: $0) }
        XCTAssertEqual(viewModel.items, expectedItems)
        XCTAssertEqual(fetchCompletionCalls, 1)
    }
    
    func test_whenFetchUsersUseCaseReturnsCachedData_thenViewModelShowsFirstCachedDataAndThenFetchedData() {
        
        // given
        let fetchTrendingRepositoriesUseCaseMock = FetchTrendingRepositoriesUseCaseMock()
        var fetchCompletionCalls = 0
        
        let pageUpdated = TrendingRepositoriesPage(
            items: [
                .stub(name: "UpdatedRepository1"),
                .stub(name: "UpdatedRepository2"),
            ]
        )
        
        let viewModel = DefaultTrendingRepositoriesListViewModel.make(
            fetchTrendingRepositoriesUseCase: fetchTrendingRepositoriesUseCaseMock
        )
        
        let testItemsBeforeFreshData = {
            let expectedItems = TrendingRepositoriesListViewModelTests
                .trendingRepositoriesPage
                .items
                .map { TrendingRepositoriesListItemViewModel(repository: $0) }

            XCTAssertEqual(viewModel.items, expectedItems)
        }
        
        fetchTrendingRepositoriesUseCaseMock._fetch = { cached, completion in
            cached(TrendingRepositoriesListViewModelTests.trendingRepositoriesPage)
            
            testItemsBeforeFreshData()
            
            completion(.success(pageUpdated))
            fetchCompletionCalls += 1
        }

        // when
        viewModel.viewDidLoad()

        // then
        let expectedItems = pageUpdated
            .items
            .map { TrendingRepositoriesListItemViewModel(repository: $0) }
        XCTAssertEqual(viewModel.items, expectedItems)
        XCTAssertEqual(fetchCompletionCalls, 1)
    }
}

extension DefaultTrendingRepositoriesListViewModel {
    static func make(
        fetchTrendingRepositoriesUseCase: FetchTrendingRepositoriesUseCase
    ) -> DefaultTrendingRepositoriesListViewModel {
        DefaultTrendingRepositoriesListViewModel(
            fetchTrendingRepositoriesUseCase: fetchTrendingRepositoriesUseCase,
            mainQueue: DispatchQueueTypeMock()
        )
    }
}
