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
        
        // Header Image
        let headerImageView = UIImageView()
        headerImageView.image = App?.color
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerImageView)

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
        view.addSubview(titleLabel)

        // Event Date
        let dateLabel = UILabel()
        dateLabel.text = "April 26th and 27th"
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)

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
            tagButton.setTitleColor(.white, for: .normal)
            tagButton.backgroundColor = .systemBlue
            tagButton.layer.cornerRadius = 8
            tagButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            tagStackView.addArrangedSubview(tagButton)
        }
        view.addSubview(tagStackView)

        // Description
        let descriptionLabel = UILabel()
        descriptionLabel.text = App?.desc
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)

        // Venue Location
        let venueLabel = UILabel()
        if let loc = App?.location {
            venueLabel.text = "📍 " + loc
        }
        venueLabel.font = UIFont.boldSystemFont(ofSize: 16)
        venueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(venueLabel)

        // Directions Button
        let directionsButton = UIButton()
        directionsButton.setTitle("Get Directions", for: .normal)
        directionsButton.setTitleColor(.white, for: .normal)
        directionsButton.backgroundColor = .systemBlue
        directionsButton.layer.cornerRadius = 8
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(directionsButton)

        // Rating and Reviews Stack View
        let ratingAndReviewsStackView = UIStackView()
        ratingAndReviewsStackView.axis = .horizontal
        ratingAndReviewsStackView.alignment = .center
        ratingAndReviewsStackView.distribution = .equalSpacing
        ratingAndReviewsStackView.spacing = 8
        ratingAndReviewsStackView.translatesAutoresizingMaskIntoConstraints = false

        let ratingStackView = UIStackView()
        ratingStackView.axis = .horizontal
        ratingStackView.alignment = .center
        ratingStackView.spacing = 4
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false

        for _ in 0..<5 {
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
            starImageView.tintColor = .systemYellow
            ratingStackView.addArrangedSubview(starImageView)
        }

        let reviewsButton = UIButton()
        reviewsButton.setTitle("Reviews →", for: .normal)
        reviewsButton.setTitleColor(.systemBlue, for: .normal)
        reviewsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)

        ratingAndReviewsStackView.addArrangedSubview(ratingStackView)
        ratingAndReviewsStackView.addArrangedSubview(reviewsButton)
        view.addSubview(ratingAndReviewsStackView)

        // Booking Button
        let bookingButton = UIButton()
        bookingButton.setTitle("From 10.000 BD | Book Now", for: .normal)
        bookingButton.setTitleColor(.white, for: .normal)
        bookingButton.backgroundColor = .systemGreen
        bookingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        bookingButton.layer.cornerRadius = 8
        bookingButton.translatesAutoresizingMaskIntoConstraints = false
        bookingButton.addTarget(self, action: #selector(openBookingView), for: .touchUpInside)
        view.addSubview(bookingButton)

        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            // Header Image Constraints
            headerImageView.topAnchor.constraint(equalTo: view.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Date Label Constraints
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Tag Stack View Constraints
            tagStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 24),
            tagStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Description Label Constraints
            descriptionLabel.topAnchor.constraint(equalTo: tagStackView.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Venue Label Constraints
            venueLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            venueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            // Directions Button Constraints
            directionsButton.topAnchor.constraint(equalTo: venueLabel.bottomAnchor, constant: 16),
            directionsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            directionsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            directionsButton.heightAnchor.constraint(equalToConstant: 44),

            // Rating and Reviews Stack View Constraints
            ratingAndReviewsStackView.topAnchor.constraint(equalTo: directionsButton.bottomAnchor, constant: 24),
            ratingAndReviewsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ratingAndReviewsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Booking Button Constraints
            bookingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            bookingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bookingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bookingButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func openBookingView() {
        let bookingVC = BookingViewController() // Replace with storyboard instantiation if necessary
        bookingVC.App = App
        navigationController?.pushViewController(bookingVC, animated: true)
    }
}
