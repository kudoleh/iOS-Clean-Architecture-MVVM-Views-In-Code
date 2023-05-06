import UIKit

final class TrendingRepositoriesListViewController: UIViewController {
    
    private var viewModel: TrendingRepositoriesListViewModel
    private let imagesRepository: ImagesRepository
    private lazy var itemsTableViewController = TrendingRepositoriesListTableViewController(
        viewModel: viewModel,
        imagesRepository: imagesRepository
    )

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

        setupLocalizations()
        setupViewLayout()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    private func bind(to viewModel: TrendingRepositoriesListViewModel) {
        viewModel.content.observe(on: self) { [weak self]
            _ in self?.updateItems() }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }

    private func setupLocalizations() {
        title = NSLocalizedString(
            Localizations.TrendingRepositoriesFeature.TrendingRepositoriesList.ListScreen.title,
            comment: ""
        )
    }
    
    private func setupViewLayout() {
        add(child: itemsTableViewController, container: view)
    }

    private func updateItems() {
        itemsTableViewController.reload()
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        
        let alert = UIAlertController(
            title: NSLocalizedString(
                Localizations.Common.Errors.errorTitle,
                comment: ""
            ),
            message: error,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString(
                    Localizations.Common.Errors.okButtonTitle,
                    comment: ""
                ),
                style: UIAlertAction.Style.default,
                handler: nil
            )
        )
        present(alert, animated: true)
    }
}
