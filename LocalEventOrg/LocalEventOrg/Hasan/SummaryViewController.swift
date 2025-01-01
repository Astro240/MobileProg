//
//  SummaryViewController.swift
//  LocalEventOrg
//
//  Created by BP-36-224-16 on 31/12/2024.
//

import UIKit
import FirebaseDatabase

class SummaryViewController: UIViewController {
    var App: App? // Injected App object from BookingViewController
    var selectedTickets: [String: Int] = [:]
    var userID: String? // Injected UserID
    var eventID: String? // Injected EventID
    private var paymentOverlayView: UIView?
    private var cardNumberField: UITextField!
    private var nameField: UITextField!
    private var expiryDateField: UITextField!
    private var cvvField: UITextField!

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
        summaryLabel.text = "Summary:"
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

        // Pay Now Button (with Gradient and Shadow)
        let payNowButton = UIButton(type: .system)
        payNowButton.setTitle("Pay Now", for: .normal)
        payNowButton.setTitleColor(.white, for: .normal)
        payNowButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)

        // Apply rounded corners
        payNowButton.layer.cornerRadius = 25
        payNowButton.clipsToBounds = true

        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor] // Gradient colors
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

        payNowButton.addTarget(self, action: #selector(showPaymentOverlay), for: .touchUpInside)
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

    @objc func showPaymentOverlay() {
        // Create Overlay View
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        self.paymentOverlayView = overlayView

        // Create Content View
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(contentView)

        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Credit Card Payment"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        // Payment Fields
        cardNumberField = createTextField(placeholder: "Card Number")
        nameField = createTextField(placeholder: "Name")
        expiryDateField = createTextField(placeholder: "Expiry Date")
        cvvField = createTextField(placeholder: "CVV")

        let stackView = UIStackView(arrangedSubviews: [cardNumberField, nameField, expiryDateField, cvvField])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        // Pay Button (with Gradient and Shadow)
        let payButton = UIButton(type: .system)
        payButton.setTitle("Pay", for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)

        // Apply rounded corners
        payButton.layer.cornerRadius = 25
        payButton.clipsToBounds = true

        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor] // Gradient colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 50)
        gradientLayer.cornerRadius = 25
        payButton.layer.insertSublayer(gradientLayer, at: 0)

        // Add shadow
        payButton.layer.shadowColor = UIColor.black.cgColor
        payButton.layer.shadowOpacity = 0.3
        payButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        payButton.layer.shadowRadius = 5

        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        payButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(payButton)

        // Close Button (X)
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        closeButton.addTarget(self, action: #selector(closePaymentOverlay), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(closeButton)

        // Constraints for overlay and content view
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            payButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            payButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    @objc func closePaymentOverlay() {
        paymentOverlayView?.removeFromSuperview()
    }

    @objc func payButtonTapped() {
        // Ensure the text fields have values
        guard let cardNumber = cardNumberField.text, !cardNumber.isEmpty,
              let name = nameField.text, !name.isEmpty,
              let expiryDate = expiryDateField.text, !expiryDate.isEmpty,
              let cvv = cvvField.text, !cvv.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }

        // Validate the card number, name, expiry date, and CVV
        if !isValidCardNumber(cardNumber) {
            showAlert(title: "Invalid Card Number", message: "Credit card number must be 16 digits.")
            return
        }

        if !isValidName(name) {
            showAlert(title: "Invalid Name", message: "Name must not contain any digits.")
            return
        }

        if !isValidExpiryDate(expiryDate) {
            showAlert(title: "Invalid Expiry Date", message: "Expiry date must be in the format mm/yyyy.")
            return
        }

        if !isValidCVV(cvv) {
            showAlert(title: "Invalid CVV", message: "CVV must be 3 digits.")
            return
        }

        // If all validations pass, proceed with the payment
        let alert = UIAlertController(title: "Payment Successful", message: "Your payment was processed successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Save booking data to Firebase
            if let confirmedEventID = self.eventID, let confirmedUserID = self.userID {
                self.addBookingWithUUID(eventID: confirmedEventID, userID: confirmedUserID)
            }

            // Navigate to the confirmation screen or dismiss the overlay
            self.closePaymentOverlay()

            // Optionally, navigate to the confirmation screen
            let confirmationVC = BookingConfirmationViewController()
            confirmationVC.App = self.App
            confirmationVC.selectedTickets = self.selectedTickets
            confirmationVC.userID = self.userID // Pass UserID
            confirmationVC.eventID = self.eventID // Pass EventID

            if let navigationController = self.navigationController {
                navigationController.pushViewController(confirmationVC, animated: true)
            } else {
                self.present(confirmationVC, animated: true, completion: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    private func addBookingWithUUID(eventID: String, userID: String) {
        // Reference to the Firebase Realtime Database
        let databaseRef = Database.database().reference()

        // Generate a unique UUID for the booking
        let bookingUUID = UUID().uuidString

        // Booking data
        let bookingData: [String: Any] = [
            "EventID": eventID,
            "UserID": userID
        ]

        // Save booking data under the Booking node with UUID
        databaseRef.child("Booking").child(bookingUUID).setValue(bookingData) { error, _ in
            if let error = error {
                print("Error saving booking: \(error.localizedDescription)")
            } else {
                print("Booking successfully added with UUID: \(bookingUUID)")
            }
        }
    }

    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func isValidCardNumber(_ cardNumber: String) -> Bool {
        let trimmed = cardNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count == 16 && trimmed.allSatisfy({ $0.isNumber })
    }

    private func isValidName(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && !trimmed.contains(where: { $0.isNumber })
    }

    private func isValidExpiryDate(_ expiryDate: String) -> Bool {
        let trimmed = expiryDate.trimmingCharacters(in: .whitespacesAndNewlines)
        let regex = #"^(0[1-9]|1[0-2])/\d{4}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: trimmed)
    }

    private func isValidCVV(_ cvv: String) -> Bool {
        let trimmed = cvv.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count == 3 && trimmed.allSatisfy({ $0.isNumber })
    }
}
