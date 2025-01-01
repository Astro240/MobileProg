import UIKit

/// A custom UITableViewCell to display each event (Upcoming or Past).
/// All layout is done in code; the storyboard cell only needs the reuse ID "ActivityCell".
class ActivityTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Layout
    
    private func setupUI() {
        contentView.addSubview(eventImageView)
        contentView.addSubview(eventTitleLabel)
        
        NSLayoutConstraint.activate([
            // Image pinned top, left & right with some padding
            eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            eventImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            // Height is 50% of the cell's width
            eventImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            
            // Label below the image with side padding
            eventTitleLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 12),
            eventTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            eventTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configure Cell
    
    func configure(with event: Item) {
        eventTitleLabel.text = event.app?.title
        if let image = event.app?.color {
            eventImageView.image = image
        } else {
            // Fallback if the named image doesn't exist
            eventImageView.image = UIImage(systemName: "photo")
        }
    }
}
