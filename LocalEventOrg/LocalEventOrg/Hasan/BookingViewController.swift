//
//  BookingViewController.swift
//  LocalEventOrg
//
//  Created by BP-36-224-16 on 29/12/2024.
//


import UIKit

class BookingViewController: UIViewController {
    var App: App? // Injected App object from EventViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // ScrollView for Tickets
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // Ticket Stack View
        let ticketStackView = UIStackView()
        ticketStackView.axis = .vertical
        ticketStackView.spacing = 16
        ticketStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ticketStackView)

        // Fake Ticket Data
        let tickets = [
            (type: "Silver", price: "10.000 BHD", description: "3-day access"),
            (type: "Gold", price: "20.000 BHD", description: "3-day access + Gift Box"),
            (type: "Diamond", price: "50.000 BHD", description: "All access + VIP lounge + Meet & Greet")
        ]

        // Add Tickets
        for ticket in tickets {
            let ticketView = createTicketView(type: ticket.type, price: ticket.price, description: ticket.description)
            ticketStackView.addArrangedSubview(ticketView)
        }

        // Booking Button
        let bookingButton = UIButton()
        bookingButton.setTitle("Proceed to Payment", for: .normal)
        bookingButton.setTitleColor(.white, for: .normal)
        bookingButton.backgroundColor = .systemGreen
        bookingButton.layer.cornerRadius = 8
        bookingButton.translatesAutoresizingMaskIntoConstraints = false
        bookingButton.addTarget(self, action: #selector(proceedToPayment), for: .touchUpInside)
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

            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bookingButton.topAnchor, constant: -16),

            // Content View Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Ticket Stack View Constraints
            ticketStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            ticketStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ticketStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ticketStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // Booking Button Constraints
            bookingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bookingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bookingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bookingButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func createTicketView(type: String, price: String, description: String) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 8
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.lightGray.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = type
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)

        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(descriptionLabel)

        let priceLabel = UILabel()
        priceLabel.text = price
        priceLabel.font = UIFont.systemFont(ofSize: 16)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(priceLabel)

        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),

            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),

            container.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16)
        ])

        return container
    }

    @objc private func proceedToPayment() {
        print("Proceeding to payment...")
    }
}
