import UIKit

final class TrendingRepositoriesListItemCell: UITableViewCell {
    
    private enum Constants {
        static let ownerImageSize: CGFloat = 40
        static let languageColorImageSize: CGFloat = 10
        static let starImageSize: CGFloat = 18
        static let horizontalSpaceBetweenLanguageAndStars: CGFloat = 24
        static let horizontalSpaceBetweenImageAndTextContent: CGFloat = 12
        static let horizontalSpaceBetweenLanguageColorAndLabel: CGFloat = 8
        static let horizontalSpaceBetweenStarImageAndLabel: CGFloat = 6
        static let verticalSpaceBetweenText: CGFloat = 10
    }
    
    private lazy var horizontalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            ownerNameLabel,
            repositoryNameLabel,
            repositoryDetailsStack
        ])
        stack.axis = .vertical
        stack.spacing = Constants.verticalSpaceBetweenText
        return stack
    }()
    
    private lazy var repositoryDetailsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            repositoryDescriptionLabel,
            repositoryLanguageAndStartsStack
        ])
        stack.axis = .vertical
        stack.spacing = Constants.verticalSpaceBetweenText
        return stack
    }()
    
    private lazy var repositoryLanguageAndStartsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            repositoryLanguageStack,
            repositoryStartsStack,
            rightLanguageAndStarsSpace
        ])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = Constants.horizontalSpaceBetweenLanguageAndStars
        
        return stack
    }()
    
    private lazy var rightLanguageAndStarsSpace = UIView()

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
    
    private let repositoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var repositoryLanguageStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            repositoryLanguageColorView,
            repositoryLanguageLabel
        ])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Constants.horizontalSpaceBetweenLanguageColorAndLabel
        return stack
    }()
    
    private let repositoryLanguageColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.languageColorImageSize / 2
        view.layer.masksToBounds = true
        return view
    }()
    
    private let repositoryLanguageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var repositoryStartsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            repositoryStarImageView,
            repositoryStarsLabel
        ])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Constants.horizontalSpaceBetweenStarImageAndLabel
        return stack
    }()
    
    private let repositoryStarImageView: UIImageView = {
        let image = UIImage(
            named: Images.Common.Icons.star
        )?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemOrange
        return imageView
    }()
    
    private let repositoryStarsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var ownerImageLoadTask: Cancellable? {
        willSet { ownerImageLoadTask?.cancel() }
    }
    private var ownerImageUrl: String?
    private let mainQueue: DispatchQueueType = DispatchQueue.main

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
        setupViewLayout()
    }

    private func setupViewLayout() {
        contentView.addSubview(ownerImageView)
        contentView.addSubview(horizontalStack)
        
        ownerImageView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        repositoryStarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        repositoryLanguageColorView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        NSLayoutConstraint.activate([
            repositoryLanguageColorView.widthAnchor.constraint(equalToConstant: Constants.languageColorImageSize),
            repositoryLanguageColorView.heightAnchor.constraint(equalToConstant: Constants.languageColorImageSize)
        ])
        
        NSLayoutConstraint.activate([
            repositoryStarImageView.widthAnchor.constraint(equalToConstant: Constants.starImageSize),
            repositoryStarImageView.heightAnchor.constraint(equalToConstant: Constants.starImageSize)
        ])
        
        rightLanguageAndStarsSpace.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        rightLanguageAndStarsSpace.setContentCompressionResistancePriority(
            .fittingSizeLevel,
            for: .horizontal
        )

    }

    override internal func prepareForReuse() {
        super.prepareForReuse()
        repositoryNameLabel.text = nil
        ownerNameLabel.text = nil
    }

    internal func configure(
        with model: TrendingRepositoriesListItemViewModel,
        imagesRepository: ImagesRepository
    ) {
        repositoryNameLabel.text = model.repository.name
        ownerNameLabel.text = model.repository.owner.name
        repositoryDescriptionLabel.text = model.repository.description
        repositoryLanguageLabel.text = model.repository.language
        repositoryLanguageStack.isHidden = model.repository.language == nil
        repositoryStarsLabel.text = model.repository.stargazersCountFormatted
        repositoryLanguageColorView.backgroundColor = model.repository.languageColor

        repositoryDetailsStack.isHidden = !model.isExpanded

        updateOwnerImage(
            imagesRepository: imagesRepository,
            imageUrl: model.repository.owner.avatarUrl
        )
    }
    
    private func updateOwnerImage(
        imagesRepository: ImagesRepository,
        imageUrl: String
    ) {
        ownerImageView.image = nil

        ownerImageUrl = imageUrl
        ownerImageLoadTask = imagesRepository.fetchImage(
            with: imageUrl,
            size: Int(Constants.ownerImageSize * UIScreen.main.scale)
        ) { [weak self] result in
            self?.mainQueue.async {
                defer { self?.ownerImageLoadTask = nil }
                guard self?.ownerImageUrl == imageUrl else { return }
                if case let .success(data) = result {
                    self?.ownerImageView.image = UIImage(data: data)
                }
            }
        }
    }
}
