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
        label.font = UIFont.boldSystemFont(ofSize: 18)
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
        
        // Constrain the eventImageView to be full width, half as tall as the cell’s width
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            eventImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            // Make the image’s height half of the cell’s width
            eventImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            
            // Place the label below the image, with some padding
            eventTitleLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 8),
            eventTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            eventTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    /// Populates the cell with data from a given Event.
    func configure(with event: Event) {
        eventTitleLabel.text = event.name
        
        // Attempt to load an image from your Assets catalog.
        // If none is found, default to a placeholder system image.
        if let image = UIImage(named: event.imageName) {
            eventImageView.image = image
        } else {
            eventImageView.image = UIImage(systemName: "photo")
        }
        
    }
    
}
