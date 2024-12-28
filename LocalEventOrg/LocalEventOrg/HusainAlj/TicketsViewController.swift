import UIKit

// MARK: - Ticket & Ticket Storage
struct Ticket {
    var title: String
    var desc: String
    var price: Int
}

class TicketStorage {
    static var tickets: [Ticket] = [
        Ticket(title: "", desc: "", price: 0),
        Ticket(title: "", desc: "", price: 0),
        Ticket(title: "", desc: "", price: 0)
    ]
}

// MARK: - TICKETS VIEW CONTROLLER
class TicketsViewController: UIViewController {

    private let labelEventTickets: UILabel = {
        let label = UILabel()
        label.text = "Event Tickets"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let buttonAddTicket: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 26, weight: .bold)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let stackViewTickets: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // A wide blue "Create" button with rounded edges
    private let buttonCreate: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Create", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private var ticketContainers: [UIView] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Create Event"

        setupSubviews()
        setupConstraints()

        // Build UI for each ticket
        for i in 0..<TicketStorage.tickets.count {
            addTicketView(index: i)
        }

        buttonAddTicket.addTarget(self, action: #selector(didTapAddTicket), for: .touchUpInside)
        buttonCreate.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTicketViews()
    }

    // MARK: - Layout
    private func setupSubviews() {
        view.addSubview(labelEventTickets)
        view.addSubview(buttonAddTicket)
        view.addSubview(stackViewTickets)
        view.addSubview(buttonCreate)
    }

    private func setupConstraints() {
        let safe = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            labelEventTickets.topAnchor.constraint(equalTo: safe.topAnchor, constant: 20),
            labelEventTickets.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20),

            buttonAddTicket.centerYAnchor.constraint(equalTo: labelEventTickets.centerYAnchor),
            buttonAddTicket.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -20),

            stackViewTickets.topAnchor.constraint(equalTo: labelEventTickets.bottomAnchor, constant: 20),
            stackViewTickets.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20),
            stackViewTickets.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -20),

            buttonCreate.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -20),
            buttonCreate.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 40),
            buttonCreate.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -40)
        ])
    }

    // MARK: - Building Tickets UI
    private func addTicketView(index: Int) {
        let container = UIView()
        container.backgroundColor = .systemGray5
        container.layer.cornerRadius = 8
        container.translatesAutoresizingMaskIntoConstraints = false

        let textFieldTitle = UITextField()
        textFieldTitle.placeholder = "Ticket Title"
        textFieldTitle.borderStyle = .roundedRect
        textFieldTitle.translatesAutoresizingMaskIntoConstraints = false
        textFieldTitle.text = TicketStorage.tickets[index].title
        textFieldTitle.tag = index + 1000
        textFieldTitle.addTarget(self, action: #selector(titleFieldChanged(_:)), for: .editingChanged)

        let textFieldDesc = UITextField()
        textFieldDesc.placeholder = "Ticket Description"
        textFieldDesc.borderStyle = .roundedRect
        textFieldDesc.translatesAutoresizingMaskIntoConstraints = false
        textFieldDesc.text = TicketStorage.tickets[index].desc
        textFieldDesc.tag = index + 2000
        textFieldDesc.addTarget(self, action: #selector(descFieldChanged(_:)), for: .editingChanged)

        let textFieldPrice = UITextField()
        textFieldPrice.placeholder = "0"
        textFieldPrice.borderStyle = .roundedRect
        textFieldPrice.keyboardType = .numberPad
        textFieldPrice.translatesAutoresizingMaskIntoConstraints = false
        textFieldPrice.tag = index + 3000
        textFieldPrice.text = "\(TicketStorage.tickets[index].price)"
        textFieldPrice.addTarget(self, action: #selector(priceFieldChanged(_:)), for: .editingChanged)

        let labelBD = UILabel()
        labelBD.text = "BD"
        labelBD.font = .systemFont(ofSize: 16, weight: .semibold)
        labelBD.translatesAutoresizingMaskIntoConstraints = false

        let buttonMinus = UIButton(type: .system)
        buttonMinus.setTitle("-", for: .normal)
        buttonMinus.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        buttonMinus.translatesAutoresizingMaskIntoConstraints = false
        buttonMinus.tag = index
        buttonMinus.addTarget(self, action: #selector(didTapMinus(_:)), for: .touchUpInside)

        let buttonPlus = UIButton(type: .system)
        buttonPlus.setTitle("+", for: .normal)
        buttonPlus.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        buttonPlus.translatesAutoresizingMaskIntoConstraints = false
        buttonPlus.tag = index
        buttonPlus.addTarget(self, action: #selector(didTapPlus(_:)), for: .touchUpInside)

        let buttonDelete = UIButton(type: .system)
        buttonDelete.setTitle("Delete", for: .normal)
        buttonDelete.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        buttonDelete.translatesAutoresizingMaskIntoConstraints = false
        buttonDelete.tag = index
        buttonDelete.addTarget(self, action: #selector(didTapDelete(_:)), for: .touchUpInside)

        // Add subviews
        container.addSubview(textFieldTitle)
        container.addSubview(textFieldDesc)
        container.addSubview(textFieldPrice)
        container.addSubview(labelBD)
        container.addSubview(buttonMinus)
        container.addSubview(buttonPlus)
        container.addSubview(buttonDelete)

        // Constraints
        NSLayoutConstraint.activate([
            textFieldTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            textFieldTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            textFieldTitle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            textFieldTitle.heightAnchor.constraint(equalToConstant: 34),

            textFieldDesc.topAnchor.constraint(equalTo: textFieldTitle.bottomAnchor, constant: 8),
            textFieldDesc.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            textFieldDesc.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            textFieldDesc.heightAnchor.constraint(equalToConstant: 34),

            textFieldPrice.topAnchor.constraint(equalTo: textFieldDesc.bottomAnchor, constant: 8),
            textFieldPrice.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            textFieldPrice.widthAnchor.constraint(equalToConstant: 60),
            textFieldPrice.heightAnchor.constraint(equalToConstant: 34),

            labelBD.centerYAnchor.constraint(equalTo: textFieldPrice.centerYAnchor),
            labelBD.leadingAnchor.constraint(equalTo: textFieldPrice.trailingAnchor, constant: 6),

            buttonMinus.centerYAnchor.constraint(equalTo: textFieldPrice.centerYAnchor),
            buttonMinus.leadingAnchor.constraint(equalTo: labelBD.trailingAnchor, constant: 20),

            buttonPlus.centerYAnchor.constraint(equalTo: textFieldPrice.centerYAnchor),
            buttonPlus.leadingAnchor.constraint(equalTo: buttonMinus.trailingAnchor, constant: 16),

            buttonDelete.centerYAnchor.constraint(equalTo: textFieldPrice.centerYAnchor),
            buttonDelete.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),

            container.bottomAnchor.constraint(equalTo: textFieldPrice.bottomAnchor, constant: 8)
        ])

        ticketContainers.append(container)
        stackViewTickets.addArrangedSubview(container)
    }

    private func reloadTicketViews() {
        for view in ticketContainers {
            stackViewTickets.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        ticketContainers.removeAll()

        for i in 0..<TicketStorage.tickets.count {
            addTicketView(index: i)
        }
    }

    // MARK: - Button Actions
    @objc private func didTapAddTicket() {
        TicketStorage.tickets.append(Ticket(title: "", desc: "", price: 0))
        reloadTicketViews()
    }

    @objc private func didTapMinus(_ sender: UIButton) {
        let index = sender.tag
        var t = TicketStorage.tickets[index]
        t.price = max(0, t.price - 10)
        TicketStorage.tickets[index] = t
        reloadTicketViews()
    }

    @objc private func didTapPlus(_ sender: UIButton) {
        let index = sender.tag
        var t = TicketStorage.tickets[index]
        t.price += 10
        TicketStorage.tickets[index] = t
        reloadTicketViews()
    }

    @objc private func didTapDelete(_ sender: UIButton) {
        let index = sender.tag
        TicketStorage.tickets.remove(at: index)
        reloadTicketViews()
    }

    // MARK: - TextField Editing
    @objc private func titleFieldChanged(_ sender: UITextField) {
        let index = sender.tag - 1000
        if index >= 0 && index < TicketStorage.tickets.count {
            TicketStorage.tickets[index].title = sender.text ?? ""
        }
    }

    @objc private func descFieldChanged(_ sender: UITextField) {
        let index = sender.tag - 2000
        if index >= 0 && index < TicketStorage.tickets.count {
            TicketStorage.tickets[index].desc = sender.text ?? ""
        }
    }

    @objc private func priceFieldChanged(_ sender: UITextField) {
        let index = sender.tag - 3000
        if index >= 0 && index < TicketStorage.tickets.count {
            let textValue = sender.text ?? ""
            let numericValue = Int(textValue) ?? 0
            TicketStorage.tickets[index].price = numericValue
        }
    }

    // MARK: - "Create" Button
    @objc private func didTapCreate() {
        // Check if any ticket is missing title or desc
        for ticket in TicketStorage.tickets {
            if ticket.title.isEmpty || ticket.desc.isEmpty {
                let alert = UIAlertController(
                    title: "Error",
                    message: "Please fill in all fields for each ticket.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
        }

        // If OK, show "Event Created!" popup
        let createdAlert = UIAlertController(
            title: "Event Created!",
            message: nil,
            preferredStyle: .alert
        )
        createdAlert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: { _ in
                // Then reset everything
                self.resetAllData()
                // popToRoot => go back to first page
                self.navigationController?.popToRootViewController(animated: true)
            })
        )
        present(createdAlert, animated: true)
    }

    private func resetAllData() {
        // Reset event data
        EventData.title = ""
        EventData.longitude = ""
        EventData.latitude = ""
        EventData.startDate = Date()
        EventData.endDate = Date()
        EventData.description = ""
        EventData.selectedCategories = []
        EventData.eventImage = nil

        // Reset tickets
        for i in 0..<TicketStorage.tickets.count {
            TicketStorage.tickets[i] = Ticket(title: "", desc: "", price: 0)
        }
    }
}
