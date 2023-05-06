import UIKit

final class TrendingRepositoriesListLoadingItemCell: UITableViewCell, SkeletonLoadable {

    private enum Constants {
        static let ownerImageSize: CGFloat = 40
        static let horizontalSpaceBetweenImageAndTextContent: CGFloat = 12
        static let verticalSpaceBetweenText: CGFloat = 10
    }
    
    private lazy var horizontalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            ownerNameLabel,
            repositoryNameLabel
        ])
        stack.axis = .vertical
        stack.spacing = Constants.verticalSpaceBetweenText
        return stack
    }()

    private let ownerNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ownerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.ownerImageSize / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let repositoryNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let ownerImageLayer = CAGradientLayer()
    let repositoryNameLayer = CAGradientLayer()
    let ownerNameLayer = CAGradientLayer()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required internal init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setup()
        setupViewLayout()
    }
    
    func setup() {
        
        backgroundColor = .secondarySystemGroupedBackground
        selectionStyle = .none
        
        repositoryNameLabel.text = "repo"
        ownerNameLabel.text = "owner"
        
        repositoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        ownerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        ownerImageLayer.startPoint = CGPoint(x: 0, y: 0.5)
        ownerImageLayer.endPoint = CGPoint(x: 1, y: 0.5)
        ownerImageView.layer.addSublayer(ownerImageLayer)
        
        ownerNameLayer.startPoint = CGPoint(x: 0, y: 0.5)
        ownerNameLayer.endPoint = CGPoint(x: 1, y: 0.5)
        ownerNameLabel.layer.addSublayer(ownerNameLayer)
        
        repositoryNameLayer.startPoint = CGPoint(x: 0, y: 0.5)
        repositoryNameLayer.endPoint = CGPoint(x: 1, y: 0.5)
        repositoryNameLabel.layer.addSublayer(repositoryNameLayer)
        
        let ownerImageGroup = makeAnimationGroup()
        ownerImageGroup.beginTime = 0.0
        ownerImageLayer.add(ownerImageGroup, forKey: "backgroundColor")
        
        let ownerNameGroup = makeAnimationGroup(previousGroup: ownerImageGroup)
        ownerNameLayer.add(ownerNameGroup, forKey: "backgroundColor")
        
        let reponameGroup = makeAnimationGroup(previousGroup: ownerImageGroup)
        reponameGroup.beginTime = 0.0
        repositoryNameLayer.add(reponameGroup, forKey: "backgroundColor")
    }
    
    private func setupViewLayout() {
        contentView.addSubview(ownerImageView)
        contentView.addSubview(horizontalStack)
        
        ownerImageView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        let guide = contentView.layoutMarginsGuide

        NSLayoutConstraint.activate([
            ownerImageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 5),
            guide.bottomAnchor.constraint(greaterThanOrEqualTo: ownerImageView.bottomAnchor),
            ownerImageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            ownerImageView.widthAnchor.constraint(equalToConstant: Constants.ownerImageSize),
            ownerImageView.heightAnchor.constraint(equalToConstant: Constants.ownerImageSize)
        ])
        
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: guide.topAnchor),
            guide.bottomAnchor.constraint(equalTo: horizontalStack.bottomAnchor),
            horizontalStack.leadingAnchor.constraint(
                equalTo: ownerImageView.trailingAnchor,
                constant: Constants.horizontalSpaceBetweenImageAndTextContent
            ),
            guide.trailingAnchor.constraint(equalTo: horizontalStack.trailingAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ownerImageLayer.frame = .init(
            origin: .zero,
            size: .init(
                width: ownerImageView.bounds.width,
                height: ownerImageView.bounds.height
            )
        )

        ownerNameLayer.frame = .init(
            origin: .zero,
            size: .init(
                width: ownerNameLabel.bounds.width / 3,
                height: ownerNameLabel.bounds.height
            )
        )

        repositoryNameLayer.frame = .init(
            origin: .zero,
            size: .init(
                width: repositoryNameLabel.bounds.width / 2,
                height: repositoryNameLabel.bounds.height
            )
        )

        ownerNameLayer.cornerRadius = ownerNameLabel.bounds.height / 2
        repositoryNameLayer.cornerRadius = repositoryNameLabel.bounds.height / 2
    }
}
