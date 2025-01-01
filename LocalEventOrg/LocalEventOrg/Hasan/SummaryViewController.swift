//
//  SummaryViewController.swift
//  LocalEventOrg
//
//  Created by BP-36-224-16 on 31/12/2024.
//

import UIKit

class SummaryViewController: UIViewController {
    var App: App? // Injected App object from BookingViewController
    var selectedTickets: [String: Int] = [:]

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

        // Event Title
        let titleLabel = UILabel()
        titleLabel.text = app.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Summary Label
        let summaryLabel = UILabel()
        summaryLabel.text = "Your Booking Summary:"
        summaryLabel.font = UIFont.boldSystemFont(ofSize: 18)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryLabel)

        // Stack View for Details
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // Calculate Prices
        var subtotal: Double = 0.0
        if let ticketPrices = app.price as? [String: Double] {
            for (ticketType, quantity) in selectedTickets {
                guard let price = ticketPrices[ticketType] else { continue }
                let totalPrice = Double(quantity) * price
                subtotal += totalPrice

                let detailLine = UILabel()
                detailLine.text = "\(quantity) x \(ticketType) @ \(price) BHD"
                detailLine.font = UIFont.systemFont(ofSize: 16)
                detailLine.textColor = .black
                stackView.addArrangedSubview(detailLine)
            }
        }

        // VAT and Total Calculation
        let vat = subtotal * 0.10
        let total = subtotal + vat

        // Subtotal Label
        let subtotalLabel = UILabel()
        subtotalLabel.text = String(format: "Subtotal: %.3f BHD", subtotal)
        subtotalLabel.font = UIFont.systemFont(ofSize: 16)
        stackView.addArrangedSubview(subtotalLabel)

        // VAT Label
        let vatLabel = UILabel()
        vatLabel.text = String(format: "VAT (10%%): %.3f BHD", vat)
        vatLabel.font = UIFont.systemFont(ofSize: 16)
        stackView.addArrangedSubview(vatLabel)

        // Total Label
        let totalLabel = UILabel()
        totalLabel.text = String(format: "Total: %.3f BHD", total)
        totalLabel.font = UIFont.boldSystemFont(ofSize: 18)
        stackView.addArrangedSubview(totalLabel)

        // Pay Now Button
        let payNowButton = UIButton(type: .system)
        payNowButton.setTitle("Pay Now", for: .normal)
        payNowButton.setTitleColor(.white, for: .normal)
        payNowButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)

        // Apply rounded corners
        payNowButton.layer.cornerRadius = 25
        payNowButton.clipsToBounds = true

        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 50)
        gradientLayer.cornerRadius = 25
        payNowButton.layer.insertSublayer(gradientLayer, at: 0)

        // Add shadow
        payNowButton.layer.shadowColor = UIColor.black.cgColor
        payNowButton.layer.shadowOpacity = 0.3
        payNowButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        payNowButton.layer.shadowRadius = 5

        payNowButton.addTarget(self, action: #selector(payNowButtonTapped), for: .touchUpInside)
        payNowButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(payNowButton)

        // Constraints
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: view.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),

            titleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            stackView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            payNowButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            payNowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            payNowButton.heightAnchor.constraint(equalToConstant: 50),
            payNowButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    @objc func payNowButtonTapped() {
        // Handle the Pay Now button tap
        print("Pay Now button tapped!")
    }
}
