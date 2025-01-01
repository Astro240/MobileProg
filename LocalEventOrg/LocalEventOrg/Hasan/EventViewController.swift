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
        dateLabel.text = App?.date
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
            styleButton(tagButton)

            // Increase roundness for category buttons
            tagButton.layer.cornerRadius = 16 // Larger corner radius for rounded appearance

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
            venueLabel.text = "\u{1F4CD} " + loc
        }
        venueLabel.font = UIFont.boldSystemFont(ofSize: 16)
        venueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(venueLabel)

        // Directions Button
        let directionsButton = UIButton()
        directionsButton.setTitle("Get Directions", for: .normal)
        styleButton(directionsButton)
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(directionsButton)

        // Booking Button
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
            directionsButton.heightAnchor.constraint(equalToConstant: 50),

            // Booking Button Constraints
            bookingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
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

        // Gradient Layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 25
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 50)
        button.layer.insertSublayer(gradientLayer, at: 0)

        // Shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 5
    }

    @objc func openBookingView() {
        let bookingVC = BookingViewController() // Replace with storyboard instantiation if necessary
        bookingVC.App = App
        navigationController?.pushViewController(bookingVC, animated: true)
    }
}
