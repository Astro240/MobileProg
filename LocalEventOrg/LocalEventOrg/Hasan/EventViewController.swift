//
//  EventViewController.swift
//  LocalEventOrg
//
//  Created by BP-36-224-16 on 29/12/2024.
//

import UIKit

class EventViewController: UIViewController {
    var App: App?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Add a Scroll View
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        // Add a Content View inside the Scroll View
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Header Image
        let headerImageView = UIImageView()
        headerImageView.image = App?.color
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerImageView)

        // Event Title
        let titleLabel = UILabel()
        titleLabel.text = App?.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        // Event Date
        let dateLabel = UILabel()
        dateLabel.text = App?.date
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)

        // Tag Stack View
        guard let tags = App?.eventcategories else { return }
        let tagStackView = UIStackView()
        tagStackView.axis = .horizontal
        tagStackView.distribution = .fillEqually
        tagStackView.spacing = 8
        tagStackView.translatesAutoresizingMaskIntoConstraints = false

        for tag in tags {
            let tagButton = UIButton()
            tagButton.setTitle(tag, for: .normal)
            styleButton(tagButton)
            tagButton.layer.cornerRadius = 16
            tagStackView.addArrangedSubview(tagButton)
        }
        contentView.addSubview(tagStackView)

        // Description
        let descriptionLabel = UILabel()
        descriptionLabel.text = App?.desc
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)

        // Venue Location
        let venueLabel = UILabel()
        if let loc = App?.location {
            venueLabel.text = "\u{1F4CD} " + loc
        }
        venueLabel.font = UIFont.boldSystemFont(ofSize: 16)
        venueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(venueLabel)

        // Directions Button
        let directionsButton = UIButton()
        directionsButton.setTitle("Get Directions", for: .normal)
        styleButton(directionsButton)
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(directionsButton)

        // Overall Rating and Stars
        let ratingLabel = UILabel()
        ratingLabel.text = "Overall Rating"
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 16)
        ratingLabel.textColor = .black

        let starStackView = UIStackView()
        starStackView.axis = .horizontal
        starStackView.spacing = 4
        starStackView.alignment = .center

        for _ in 1...5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(systemName: "star.fill")
            starImageView.tintColor = .systemYellow
            starStackView.addArrangedSubview(starImageView)
        }

        let overallRatingStackView = UIStackView(arrangedSubviews: [ratingLabel, starStackView])
        overallRatingStackView.axis = .horizontal
        overallRatingStackView.spacing = 8
        overallRatingStackView.alignment = .center
        overallRatingStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(overallRatingStackView)

        // Reviews Button
        let reviewsButton = UIButton(type: .system)
        reviewsButton.setTitle("Reviews", for: .normal)
        reviewsButton.setTitleColor(.white, for: .normal)
        reviewsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)

        reviewsButton.layer.cornerRadius = 25
        reviewsButton.clipsToBounds = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 50)
        gradientLayer.cornerRadius = 25
        reviewsButton.layer.insertSublayer(gradientLayer, at: 0)

        reviewsButton.layer.shadowColor = UIColor.black.cgColor
        reviewsButton.layer.shadowOpacity = 0.3
        reviewsButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        reviewsButton.layer.shadowRadius = 5

    reviewsButton.addTarget(self, action: #selector(openReviewsPage), for: .touchUpInside)
        reviewsButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reviewsButton)

        // Floating Booking Button
        let bookingButton = UIButton()
        if let ticketPrices = App?.price as? [String: Double],
           let lowestPrice = ticketPrices.values.min() {
            bookingButton.setTitle("From \(lowestPrice) BD | Book Now", for: .normal)
        } else {
            bookingButton.setTitle("Book Now", for: .normal)
        }
        styleButton(bookingButton)
        bookingButton.addTarget(self, action: #selector(openBookingView), for: .touchUpInside)
        bookingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bookingButton)

        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            // Header Image Constraints
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Date Label Constraints
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Tag Stack View Constraints
            tagStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 24),
            tagStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Description Label Constraints
            descriptionLabel.topAnchor.constraint(equalTo: tagStackView.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Venue Label Constraints
            venueLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            venueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            // Directions Button Constraints
            directionsButton.topAnchor.constraint(equalTo: venueLabel.bottomAnchor, constant: 24),
            directionsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            directionsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            directionsButton.heightAnchor.constraint(equalToConstant: 50),

            // Overall Rating Constraints
            overallRatingStackView.topAnchor.constraint(equalTo: directionsButton.bottomAnchor, constant: 24),
            overallRatingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            // Reviews Button Constraints
            reviewsButton.topAnchor.constraint(equalTo: overallRatingStackView.bottomAnchor, constant: 24),
            reviewsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reviewsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            reviewsButton.heightAnchor.constraint(equalToConstant: 50),

            // Add Extra Space Below Reviews Button
            contentView.bottomAnchor.constraint(equalTo: reviewsButton.bottomAnchor, constant: 80),

            // Floating Booking Button Constraints
            bookingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bookingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bookingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bookingButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func styleButton(_ button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 25
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 50)
        button.layer.insertSublayer(gradientLayer, at: 0)

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 5
    }

    @objc func openBookingView() {
        let bookingVC = BookingViewController()
        bookingVC.App = App
        navigationController?.pushViewController(bookingVC, animated: true)
    }

   @objc func openReviewsPage() {
     let reviewsVC = ReviewsViewController()
       reviewsVC.eventID = App?.eventID
       navigationController?.pushViewController(reviewsVC, animated: true)
   }
}
