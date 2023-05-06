import UIKit

final class TrendingRepositoriesListTableViewController: UITableViewController {
    
    private enum Constants {
        static let numberOfLoadingShimmeringCells = 8
    }
    
    private enum Section: Hashable {
        case main
    }

    private enum Cell: Hashable {
        case item(TrendingRepositoriesListItemViewModel)
        case emptyData
        case loading(index: Int)
    }

    private let viewModel: TrendingRepositoriesListViewModel
    private let imagesRepository: ImagesRepository
    private var registeredCellTypes: Set<String> = []
    
    private lazy var tableViewDataSource: UITableViewDiffableDataSource<Section, Cell> = { [weak self] in
        let dataSource = UITableViewDiffableDataSource<Section, Cell>(tableView: tableView) { tableView, _, cellItem in
            
            return self?.dequeueReusableCell(tableView, cell: cellItem)
        }
        return dataSource
    }()
    
    // MARK: - Lifecycle
    
    init(
        viewModel: TrendingRepositoriesListViewModel,
        imagesRepository: ImagesRepository
    ) {
        self.viewModel = viewModel
        self.imagesRepository = imagesRepository
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func reload() {
        updateSeparatorStyle()
        updateItems()
    }
    
    private func updateSeparatorStyle() {
        switch viewModel.content.value {
        case .emptyData:
            tableView.separatorStyle = .none
        case .items, .loading:
            tableView.separatorStyle = .singleLine
        }
    }

    private func setupViews() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    func updateItems() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Cell>()
        
        snapshot.appendSections([.main])
        switch viewModel.content.value {
        case .items(let models):
            snapshot.appendItems(models.map { .item($0) }, toSection: .main)
        case .emptyData:
            snapshot.appendItems([.emptyData], toSection: .main)
        case .loading:
            let loadingItems: [Cell] = (0..<Constants.numberOfLoadingShimmeringCells).map {
                .loading(index: $0)
            }
            snapshot.appendItems(loadingItems, toSection: .main)
        }

        tableViewDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc func refresh(_ sender: Any) {
        viewModel.viewDidLoad()
        refreshControl?.endRefreshing()
        tableView.setContentOffset(.zero, animated: true)
    }
}

// MARK: - Dequeue Reusable Cells

extension TrendingRepositoriesListTableViewController {
    
    private func dequeueReusableCell(
        _ tableView: UITableView,
        cell: Cell
    ) -> UITableViewCell {
        switch cell {
        case .item(let item):
            let cell = tableView.dequeueReusableCell(
                TrendingRepositoriesListItemCell.self,
                registeredCellTypes: &registeredCellTypes
            )
            cell.configure(
                with: item,
                imagesRepository: imagesRepository
            )
            return cell
        case .emptyData:
            return tableView.dequeueReusableCell(
                TrendingRepositoriesListEmptyItemCell.self,
                registeredCellTypes: &registeredCellTypes
            )
        case .loading:
            return tableView.dequeueReusableCell(
                TrendingRepositoriesListLoadingItemCell.self,
                registeredCellTypes: &registeredCellTypes
            )
        }
    }
}

// MARK: - UITableViewDelegate

extension TrendingRepositoriesListTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.content.value {
        case .emptyData:
            return tableView.frame.height * 0.8
        case .items, .loading:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.viewDidSelectItem(at: indexPath.row)
    }
}
