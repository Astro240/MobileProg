import UIKit

class TableViewCell: UITableViewCell {
    
    static let identifier = "EventCell"
    
    private var isBookmarked = false // State for bookmark button
    
    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12 // Rounded corners
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 2 // Support multi-line titles
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let datePriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let tagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .gray // Default color
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(eventImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(datePriceLabel)
        contentView.addSubview(tagsStackView)
        contentView.addSubview(bookmarkButton)
        
        // Add action for bookmark button
        bookmarkButton.addTarget(self, action: #selector(toggleBookmark), for: .touchUpInside)
        
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with event: App) {
        eventImageView.image = event.color
        titleLabel.text = event.title
        locationLabel.text = event.location
        datePriceLabel.text = "\(event.eventcategories.joined(separator: ", "))"
        configureTags(event.eventcategories)
    }
    
    private func configureTags(_ tags: [String]) {
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for tag in tags {
            let tagLabel = UILabel()
            tagLabel.font = UIFont.systemFont(ofSize: 12)
            tagLabel.textColor = .white
            tagLabel.text = " \(tag) "
            tagLabel.backgroundColor = .lightGray
            tagLabel.layer.cornerRadius = 8
            tagLabel.clipsToBounds = true
            tagsStackView.addArrangedSubview(tagLabel)
        }
    }
    
    @objc private func toggleBookmark() {
        isBookmarked.toggle() // Toggle the state
        let newImageName = isBookmarked ? "bookmark.fill" : "bookmark"
        let newTintColor = isBookmarked ? UIColor.systemBlue : UIColor.gray
        bookmarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
        bookmarkButton.tintColor = newTintColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageWidth: CGFloat = contentView.frame.width * 0.4
        let imageHeight: CGFloat = 120
        let padding: CGFloat = 16
        let textAreaX = imageWidth + padding * 2
        
        eventImageView.frame = CGRect(x: padding, y: padding, width: imageWidth, height: imageHeight)
        
        titleLabel.frame = CGRect(
            x: textAreaX,
            y: padding,
            width: contentView.frame.width - textAreaX - padding,
            height: 40
        )
        
        locationLabel.frame = CGRect(
            x: textAreaX,
            y: titleLabel.frame.maxY + 4,
            width: contentView.frame.width - textAreaX - padding,
            height: 20
        )
        
        datePriceLabel.frame = CGRect(
            x: textAreaX,
            y: locationLabel.frame.maxY + 4,
            width: contentView.frame.width - textAreaX - padding,
            height: 20
        )
        
        tagsStackView.frame = CGRect(
            x: textAreaX,
            y: datePriceLabel.frame.maxY + 8,
            width: contentView.frame.width - textAreaX - padding,
            height: 20
        )
        
        bookmarkButton.frame = CGRect(
            x: contentView.frame.width - padding - 24,
            y: padding,
            width: 24,
            height: 24
        )
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: contentView.frame.width, height: 150)
    }
}
