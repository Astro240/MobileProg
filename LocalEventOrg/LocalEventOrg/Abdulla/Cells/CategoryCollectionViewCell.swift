import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "CategoryCollectionViewCell"
    
    // Image view with an aspect ratio constraint
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true // Ensure the corner radius works correctly
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Title label for category name
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Stack view for image and title, aligned horizontally
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Line view for the separator at the bottom
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add the image view and title label to the stack view
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
        
        // Add the line view to the cell
        addSubview(lineView)
        
        // Define layout constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            // Keep image aspect ratio 1:1 for the image view
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            // Line view for separator at the bottom
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale) // Thin line
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure the cell with a category object
    func configureCell(_ category: StoreCategory, hideBottomLine: Bool) {
        titleLabel.text = category.name
        imageView.image = category.color // Assuming 'color' is an image, change as needed
        lineView.isHidden = hideBottomLine
    }
}
