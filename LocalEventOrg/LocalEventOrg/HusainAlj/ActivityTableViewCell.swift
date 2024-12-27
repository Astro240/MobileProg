import UIKit

/// A custom UITableViewCell to display each upcoming event.
/// All layout is done in code, so the prototype cell in Storyboard
/// should NOT contain any subviews (just the cell and an identifier).
class ActivityTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    /// An image view to hold the event’s image (programmatically created).
    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill   // fill, cropping edges
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// A label to display the event’s name (programmatically created).
    private let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20) // Slightly larger font
        label.numberOfLines = 0  // allow multiple lines if needed
        return label
    }()
    
    // MARK: - Initializers
    
    /// For cells created programmatically.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    /// For cells loaded from a storyboard or nib (required but not used).
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Layout & Configuration
    
    /// Sets up the cell’s subviews and constraints programmatically.
    private func setupUI() {
        contentView.addSubview(eventImageView)
        contentView.addSubview(eventTitleLabel)
        
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            eventImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            // Make the image’s height slightly smaller (50% of the cell’s width)
            eventImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            
            eventTitleLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 12),
            eventTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            eventTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    /// Populates the cell with data from a given Event.
    func configure(with event: Event) {
        eventTitleLabel.text = event.name

        if let image = UIImage(named: event.imageName) {
            eventImageView.image = image
            print("Loaded image: \(event.imageName)")
        } else {
            eventImageView.image = UIImage(systemName: "photo") // Placeholder
            print("Image not found: \(event.imageName)")
        }
    }
}
