import UIKit

class TrendingRepositoriesListEmptyItemCell: UITableViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required internal init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .secondarySystemGroupedBackground
        selectionStyle = .none
        label.text = NSLocalizedString(
            Localizations.TrendingRepositoriesFeature.TrendingRepositoriesList.EmptyState.emptyDataPullToRefresh,
            comment: ""
        )
        setupViewLayout()
    }

    private func setupViewLayout() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let guide = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: guide.topAnchor),
            guide.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            guide.trailingAnchor.constraint(equalTo: label.trailingAnchor)
        ])
    }
}
