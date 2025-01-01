//
//  BookingConfirmationViewController.swift
//  LocalEventOrg
//
//  Created by BP-36-215-02 on 01/01/2025.
//

import UIKit

class BookingConfirmationViewController: UIViewController {
    var App: App? // Injected App object
    var selectedTickets: [String: Int] = [:] // Injected ticket details
    var userID: String? // Injected user ID
    var eventID: String? // Injected event ID

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        guard let app = App else { return }

        view.backgroundColor = .white

        // Header Image
        let headerImageView = UIImageView()
        headerImageView.image = app.color
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerImageView)

        // Thank You Label
        let thankYouLabel = UILabel()
        thankYouLabel.text = "Thank you for your booking!"
        thankYouLabel.font = UIFont.boldSystemFont(ofSize: 24)
        thankYouLabel.textAlignment = .center
        thankYouLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thankYouLabel)

        // Event Title
        let titleLabel = UILabel()
        titleLabel.text = app.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        

           

        // Summary Label
        let summaryLabel = UILabel()
        summaryLabel.text = "Booking Summary:"
        summaryLabel.font = UIFont.boldSystemFont(ofSize: 18)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryLabel)

        // Stack View for Ticket Details
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // Calculate Prices
        var subtotal: Double = 0.0
        let ticketPrices = app.price // Assuming `app.price` is of type [String: Double]

        for (ticketType, quantity) in selectedTickets {
            guard let price = ticketPrices[ticketType] else { continue }
            let totalPrice = Double(quantity) * price
            subtotal += totalPrice

            let detailLine = UILabel()
            detailLine.text = "\(quantity) x \(ticketType)"
            detailLine.font = UIFont.systemFont(ofSize: 16)
            detailLine.textColor = .black

            let priceLabel = UILabel()
            priceLabel.text = String(format: "%.3f BHD", totalPrice)
            priceLabel.font = UIFont.systemFont(ofSize: 16)
            priceLabel.textColor = .black

            let rowStack = UIStackView(arrangedSubviews: [detailLine, priceLabel])
            rowStack.axis = .horizontal
            rowStack.distribution = .equalSpacing
            stackView.addArrangedSubview(rowStack)
        }

        // Subtotal Label
        let subtotalLabel = UILabel()
        subtotalLabel.text = String(format: "Total Paid: %.3f BHD", subtotal)
        subtotalLabel.font = UIFont.boldSystemFont(ofSize: 16)
        stackView.addArrangedSubview(subtotalLabel)

        // Done Button
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        doneButton.backgroundColor = .systemBlue
        doneButton.layer.cornerRadius = 25
        doneButton.clipsToBounds = true
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)

        // Constraints
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: view.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),

            thankYouLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 10),
            thankYouLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            thankYouLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: thankYouLabel.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            summaryLabel.topAnchor.constraint(equalTo: (userID != nil && eventID != nil ? titleLabel.bottomAnchor : summaryLabel.bottomAnchor), constant: 20),
            summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            stackView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    @objc func doneButtonTapped() {
        if let navigationController = navigationController {
            // If this view controller is part of a navigation stack
            navigationController.popToRootViewController(animated: true)
        } else {
            // Replace the root view controller
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }

            let homeViewController = HomeViewController() // Replace with actual home view controller setup
            window.rootViewController = UINavigationController(rootViewController: homeViewController)
            window.makeKeyAndVisible()
        }
    }


}
