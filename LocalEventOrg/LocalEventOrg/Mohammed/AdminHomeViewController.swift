import UIKit
import Firebase

class AdminHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!

    // MARK: - Properties
    var events: [[String: Any]] = [] // All events fetched from Firebase
    var filteredEvents: [[String: Any]] = [] // Events filtered by search or filter criteria
    var isSearching = false // Indicates if the user is actively searching

    // MARK: - Methods
    /// Sets up the view and fetches events from Firebase.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

        populateEventsForCalendar { fetchedEvents in
            DispatchQueue.main.async {
                self.events = fetchedEvents
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - UITableViewDataSource Methods
    /// Returns the number of rows to display in the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredEvents.count : events.count
    }

    /// Configures and returns a cell for the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let event = isSearching ? filteredEvents[indexPath.row] : events[indexPath.row]
        populateEventCell(cell: cell, with: event)
        return cell
    }

    // MARK: - Helper Methods
    /// Populates a table view cell with event data.
    func populateEventCell(cell: UITableViewCell, with event: [String: Any]) {
        if let eventImageView = cell.viewWithTag(1) as? UIImageView,
           let imageUrlString = event["Image"] as? String,
           let imageUrl = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        eventImageView.image = image
                    }
                }
            }
        }

        if let eventNameLabel = cell.viewWithTag(2) as? UILabel {
            eventNameLabel.text = event["Name"] as? String
        }

        if let eventDateLabel = cell.viewWithTag(3) as? UILabel {
            eventDateLabel.text = event["Date"] as? String
        }

        if let eventDescriptionLabel = cell.viewWithTag(4) as? UILabel {
            eventDescriptionLabel.text = event["Description"] as? String
        }

        if let categoryStackView = cell.viewWithTag(5) as? UIStackView {
            categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

            if let categories = event["Categories"] as? [String], !categories.isEmpty {
                for category in categories {
                    let label = UILabel()
                    label.text = category
                    label.textColor = .black
                    label.font = UIFont.systemFont(ofSize: 10)
                    label.textAlignment = .center

                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.heightAnchor.constraint(equalToConstant: 20).isActive = true
                    label.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true

                    categoryStackView.addArrangedSubview(label)
                }
            } else {
                let noCategoryLabel = UILabel()
                noCategoryLabel.text = "No Categories"
                noCategoryLabel.textColor = .darkGray
                noCategoryLabel.font = UIFont.systemFont(ofSize: 10)
                noCategoryLabel.textAlignment = .center
                categoryStackView.addArrangedSubview(noCategoryLabel)
            }
        }
    }

    // MARK: - UISearchBarDelegate Methods
    /// Filters events based on the text entered in the search bar.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredEvents = []
        } else {
            isSearching = true
            filteredEvents = events.filter { event in
                if let eventName = event["Name"] as? String {
                    return eventName.lowercased().contains(searchText.lowercased())
                }
                return false
            }
        }
        tableView.reloadData()
    }

    /// Resets the search when the cancel button is clicked.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        filteredEvents = []
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }

    // MARK: - Filter Feature
    /// Displays filter options to the user.
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        showFilterOptions()
    }

    /// Filters events based on date and category inputs.
    func showFilterOptions() {
        let alert = UIAlertController(title: "Filter Events", message: "Select filters below:", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Enter date (YYYY-MM-DD)"
            textField.keyboardType = .numbersAndPunctuation
        }

        alert.addTextField { textField in
            textField.placeholder = "Enter category (optional)"
        }

        alert.addAction(UIAlertAction(title: "Apply Filters", style: .default, handler: { _ in
            let dateText = alert.textFields?[0].text
            let categoryText = alert.textFields?[1].text
            self.applyFilters(dateText: dateText, categoryText: categoryText)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    /// Applies date and category filters to the events list.
    func applyFilters(dateText: String?, categoryText: String?) {
        filteredEvents = events.filter { event in
            var matchesDate = true
            var matchesCategory = true

            if let dateText = dateText, !dateText.isEmpty,
               let eventDateString = event["Date"] as? String,
               let enteredDate = parseDate(from: dateText),
               let eventDate = parseDate(from: eventDateString) {
                matchesDate = eventDate <= enteredDate
            }

            if let categoryText = categoryText, !categoryText.isEmpty,
               let eventCategories = event["Categories"] as? [String] {
                matchesCategory = eventCategories.contains(where: { $0.caseInsensitiveCompare(categoryText) == .orderedSame })
            }

            return matchesDate && matchesCategory
        }

        isSearching = true
        tableView.reloadData()
    }

    /// Parses a date string into a Date object.
    func parseDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }

    // MARK: - Event Management
    /// Displays management options for an event.
    @IBAction func cogIconTapped(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            showOptions(for: indexPath)
        }
    }

    /// Shows options to edit or delete an event.
    func showOptions(for indexPath: IndexPath) {
        let event = isSearching ? filteredEvents[indexPath.row] : events[indexPath.row]

        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Edit Categories", style: .default, handler: { _ in
            self.showEditCategoriesAlert(for: event, at: indexPath)
        }))

        alert.addAction(UIAlertAction(title: "Remove Post", style: .destructive, handler: { _ in
            self.confirmDeletion(for: event, at: indexPath)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    /// Displays an alert to edit the categories of an event.
    func showEditCategoriesAlert(for event: [String: Any], at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Categories", message: "Enter new categories, separated by commas.", preferredStyle: .alert)

        alert.addTextField { textField in
            if let currentCategories = event["Categories"] as? [String] {
                textField.text = currentCategories.joined(separator: ", ")
            }
        }

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let textField = alert.textFields?.first, let updatedCategories = textField.text?.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) }) {
                self.updateCategories(for: event, with: updatedCategories, at: indexPath)
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    /// Updates categories for an event in Firebase and local data.
    func updateCategories(for event: [String: Any], with newCategories: [String], at indexPath: IndexPath) {
        guard let eventName = event["Name"] as? String else { return }

        let sanitizedCategories = newCategories.filter { !$0.isEmpty }

        let ref = Database.database().reference()
        ref.child("Events").child(eventName).updateChildValues(["Categories": sanitizedCategories]) { error, _ in
            if error == nil {
                if self.isSearching {
                    self.filteredEvents[indexPath.row]["Categories"] = sanitizedCategories
                } else {
                    self.events[indexPath.row]["Categories"] = sanitizedCategories
                }
                self.tableView.reloadData()
            }
        }
    }

    /// Confirms deletion of an event.
    func confirmDeletion(for event: [String: Any], at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Are you sure?",
            message: "Do you want to delete this post?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.deletePost(event: event, at: indexPath)
        }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    /// Deletes an event from Firebase and updates the local data.
    func deletePost(event: [String: Any], at indexPath: IndexPath) {
        guard let eventName = event["Name"] as? String else { return }

        let ref = Database.database().reference()
        ref.child("Events").child(eventName).removeValue { error, _ in
            if error == nil {
                if self.isSearching {
                    self.filteredEvents.remove(at: indexPath.row)
                } else {
                    self.events.remove(at: indexPath.row)
                }
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

