import Foundation

protocol TrendingRepositoriesListViewModelInput {
    func viewDidLoad()
    func viewDidRefresh()
    func viewDidSelectItem(at index: Int)
}

protocol TrendingRepositoriesListViewModelOutput {
    var content: Observable<TrendingRepositoriesListContentViewModel> { get }
    var error: Observable<String> { get }
}

protocol TrendingRepositoriesListViewModel: TrendingRepositoriesListViewModelInput, TrendingRepositoriesListViewModelOutput {}

final class DefaultTrendingRepositoriesListViewModel: TrendingRepositoriesListViewModel {

    private let fetchTrendingRepositoriesUseCase: FetchTrendingRepositoriesUseCase

    private(set) var items: [TrendingRepositoriesListItemViewModel] = []
    private var dataLoadTask: Cancellable? { willSet { dataLoadTask?.cancel() } }

    private let mainQueue: DispatchQueueType

    // MARK: - OUTPUT

    let content: Observable<TrendingRepositoriesListContentViewModel> = Observable(.emptyData)
    let error: Observable<String> = Observable("")

    // MARK: - Init

    init(
        fetchTrendingRepositoriesUseCase: FetchTrendingRepositoriesUseCase,
        mainQueue: DispatchQueueType
    ) {
        self.fetchTrendingRepositoriesUseCase = fetchTrendingRepositoriesUseCase
        self.mainQueue = mainQueue
    }

    // MARK: - Private
    
    private func reload() {
        resetData()
        loadData()
    }
    
    private func resetData() {
        items.removeAll()
        content.value = .emptyData
    }

    private func loadData() {
        content.value = .loading
        
        dataLoadTask = fetchTrendingRepositoriesUseCase.fetch(
            cached: { [weak self] page in
                self?.mainQueue.async {
                    self?.udpate(page.items)
                }
            },
            completion: { [weak self] result in
                self?.mainQueue.async {
                    switch result {
                    case .success(let page):
                        self?.udpate(page.items)
                    case .failure(let error):
                        self?.handle(error: error)
                        self?.updateContent()
                    }
                }
            }
        )
    }
    
    private func handle(error: Error) {
        switch error.uiError {
        case .notConnectedToInternet:
            self.error.value = NSLocalizedString(
                Localizations.Common.Errors.noInternetConnection,
                comment: ""
            )
        case .cancelled:
            return
        case .generic:
            self.error.value = NSLocalizedString(
                Localizations.TrendingRepositoriesFeature.TrendingRepositoriesList.Errors.failedLoadingRepositoriesTitle,
                comment: ""
            )
        }
    }

    private func udpate(_ repositories: [Repository]) {
        items = repositories.map { TrendingRepositoriesListItemViewModel(repository: $0) }
        updateContent()
    }
    
    private func updateContent() {
        content.value = items.isEmpty
        ? .emptyData
        : .items(items)
    }
}

// MARK: - INPUT. View event methods

extension DefaultTrendingRepositoriesListViewModel {

    func viewDidLoad() {
        reload()
    }

    func viewDidRefresh() {
        reload()
    }
    
    func viewDidSelectItem(at index: Int) {
        guard case .items = content.value else { return }
        var item = items[index]
        item.isExpanded.toggle()
        items[index] = item
        content.value = .items(items)
    }
}
