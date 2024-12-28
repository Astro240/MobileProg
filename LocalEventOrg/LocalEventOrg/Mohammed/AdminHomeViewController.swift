import UIKit
import Firebase

class AdminHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    // MARK: - IBOutlets
    // UI elements connected from the storyboard
    @IBOutlet weak var tableView: UITableView! // Table view to display events
    @IBOutlet weak var searchBar: UISearchBar! // Search bar for filtering events
    @IBOutlet weak var filterButton: UIButton! // Button to trigger filter options

    // MARK: - Properties
    // Data storage for events and filtered results
    var events: [[String: Any]] = [] // All events fetched from Firebase
    var filteredEvents: [[String: Any]] = [] // Events filtered by search or filter criteria
    var isSearching = false // Indicates if the user is actively searching

    // MARK: - Lifecycle Methods
    // Called after the view has been loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()

        // Assign data source and delegate to table view
        tableView.dataSource = self
        tableView.delegate = self

        // Assign delegate to the search bar
        searchBar.delegate = self

        // Fetch events from Firebase and reload the table view
        populateEventsForCalendar { fetchedEvents in
            DispatchQueue.main.async {
                self.events = fetchedEvents
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - UITableViewDataSource Methods (Event Display)
    // Returns the number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredEvents.count : events.count
    }

    // Configures and returns a cell for the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let event = isSearching ? filteredEvents[indexPath.row] : events[indexPath.row]
        populateEventCell(cell: cell, with: event)
        return cell
    }

    // MARK: - Helper Method (Event Cell Population)
    // Populates the event cell with event data
    func populateEventCell(cell: UITableViewCell, with event: [String: Any]) {
        // Set event image
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

        // Set event name
        if let eventNameLabel = cell.viewWithTag(2) as? UILabel {
            eventNameLabel.text = event["Name"] as? String
        }

        // Set event date
        if let eventDateLabel = cell.viewWithTag(3) as? UILabel {
            eventDateLabel.text = event["Date"] as? String
        }

        // Set event description
        if let eventDescriptionLabel = cell.viewWithTag(4) as? UILabel {
            eventDescriptionLabel.text = event["Description"] as? String
        }

        // Populate categories
        if let categoryStackView = cell.viewWithTag(5) as? UIStackView {
            categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // Clear previous categories

            if let categories = event["Categories"] as? [String], !categories.isEmpty {
                for category in categories {
                    let label = UILabel()
                    label.text = category
                    label.textColor = .black
                    label.font = UIFont.systemFont(ofSize: 10)
                    label.textAlignment = .center

                    // Add padding to the label
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

    // MARK: - UISearchBarDelegate Methods (Search Feature)
    // Called when the search bar text changes
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

    // Called when the search bar cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        filteredEvents = []
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }

    // MARK: - Filter Feature
    // Action triggered by filter button
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        showFilterOptions()
    }

    // Displays filter options to the user
    func showFilterOptions() {
        let alert = UIAlertController(title: "Filter Events", message: "Select filters below:", preferredStyle: .alert)

        // Input for filtering by date
        alert.addTextField { textField in
            textField.placeholder = "Enter date (YYYY-MM-DD)"
            textField.keyboardType = .numbersAndPunctuation
        }

        // Input for filtering by category
        alert.addTextField { textField in
            textField.placeholder = "Enter category (optional)"
        }

        // Apply filters
        alert.addAction(UIAlertAction(title: "Apply Filters", style: .default, handler: { _ in
            let dateText = alert.textFields?[0].text
            let categoryText = alert.textFields?[1].text

            self.applyFilters(dateText: dateText, categoryText: categoryText)
        }))

        // Cancel filter
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    // Filters events based on input criteria
    func applyFilters(dateText: String?, categoryText: String?) {
        filteredEvents = events.filter { event in
            var matchesDate = true
            var matchesCategory = true

            // Check date filter
            if let dateText = dateText, !dateText.isEmpty,
               let eventDateString = event["Date"] as? String,
               let enteredDate = parseDate(from: dateText),
               let eventDate = parseDate(from: eventDateString) {
                matchesDate = eventDate <= enteredDate
            }

            // Check category filter
            if let categoryText = categoryText, !categoryText.isEmpty,
               let eventCategories = event["Categories"] as? [String] {
                matchesCategory = eventCategories.contains(where: { $0.caseInsensitiveCompare(categoryText) == .orderedSame })
            }

            return matchesDate && matchesCategory
        }

        isSearching = true
        tableView.reloadData()
    }

    // Helper method to parse dates
    func parseDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }

    // MARK: - Event Management (Cog Icon Actions)
    // Action triggered by tapping the cog icon
    @IBAction func cogIconTapped(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            showOptions(for: indexPath)
        }
    }

    // Displays options for managing events
    func showOptions(for indexPath: IndexPath) {
        let event = isSearching ? filteredEvents[indexPath.row] : events[indexPath.row]

        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)

        // Option to edit categories
        alert.addAction(UIAlertAction(title: "Edit Categories", style: .default, handler: { _ in
            self.showEditCategoriesAlert(for: event, at: indexPath)
        }))

        // Option to remove event
        alert.addAction(UIAlertAction(title: "Remove Post", style: .destructive, handler: { _ in
            self.confirmDeletion(for: event, at: indexPath)
        }))

        // Cancel option
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Edit Categories Feature
    // Displays an alert for editing categories
    func showEditCategoriesAlert(for event: [String: Any], at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Categories", message: "Enter new categories, separated by commas.", preferredStyle: .alert)

        // Pre-fill current categories
        alert.addTextField { textField in
            if let currentCategories = event["Categories"] as? [String] {
                textField.text = currentCategories.joined(separator: ", ")
            }
        }

        // Save updated categories
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let textField = alert.textFields?.first, let updatedCategories = textField.text?.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) }) {
                self.updateCategories(for: event, with: updatedCategories, at: indexPath)
            }
        }))

        // Cancel edit
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    // Updates categories in Firebase and local data
    func updateCategories(for event: [String: Any], with newCategories: [String], at indexPath: IndexPath) {
        guard let eventName = event["Name"] as? String else {
            print("Event name not found.")
            return
        }

        let sanitizedCategories = newCategories.filter { !$0.isEmpty }

        let ref = Database.database().reference()
        ref.child("Events").child(eventName).updateChildValues(["Categories": sanitizedCategories]) { error, _ in
            if let error = error {
                print("Error updating categories: \(error.localizedDescription)")
            } else {
                if self.isSearching {
                    self.filteredEvents[indexPath.row]["Categories"] = sanitizedCategories
                } else {
                    self.events[indexPath.row]["Categories"] = sanitizedCategories
                }
                self.tableView.reloadData()
                print("Categories updated successfully.")
            }
        }
    }

    // MARK: - Deletion Feature
    // Displays confirmation alert for deleting an event
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

    // Deletes the event from Firebase and updates local data
    func deletePost(event: [String: Any], at indexPath: IndexPath) {
        guard let eventName = event["Name"] as? String else {
            print("Event name not found")
            return
        }

        // Reference to Firebase
        let ref = Database.database().reference()
        ref.child("Events").child(eventName).removeValue { error, _ in
            if let error = error {
                print("Error deleting post: \(error.localizedDescription)")
            } else {
                // Remove the event locally
                if self.isSearching {
                    self.filteredEvents.remove(at: indexPath.row)
                } else {
                    self.events.remove(at: indexPath.row)
                }
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                print("Post deleted successfully")
            }
        }
    }
}
