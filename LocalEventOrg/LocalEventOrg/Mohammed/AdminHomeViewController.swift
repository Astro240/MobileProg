import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
// MARK: - AdminHomeViewController
/// Main view controller for managing and displaying events.
/// Handles filtering, searching, and table view functionality.
class AdminHomeViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView! // Table view displaying events
    @IBOutlet weak var searchBar: UISearchBar! // Search bar for filtering events by name

    @IBOutlet weak var LogoutAdmin: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    // MARK: - Properties
    var events: [[String: Any]] = [] // All events fetched from Firebase
    var filteredEvents: [[String: Any]] = [] // Filtered events based on user input
    var isSearching = false // Flag to indicate whether filtering or searching is active

    // MARK: - Lifecycle Methods
    /// Called after the view has been loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        fetchEvents()
    }

    // MARK: - Setup Methods
    /// Configures the table view data source and delegate.
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    /// Configures the search bar delegate.
    private func setupSearchBar() {
        searchBar.delegate = self
    }

    /// Fetches events from Firebase and reloads the table view.
    private func fetchEvents() {
        Database.database().reference().child("Events").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else { return }

            // Only include keys starting with "Event"
            let allowedKeys = value.keys.filter { $0.hasPrefix("Event") }

            // Filter events based on the allowed keys
            self.events = allowedKeys.compactMap { value[$0] }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func logoutAdminTapped(_ sender: UIButton){
        let ConfirmAlert = UIAlertController(title: "Save", message: "Would you like to Logout?", preferredStyle: .alert)
        ConfirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ConfirmAlert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                SceneDelegate.showLogin()
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
            Item.promotedApps = []
            print("User Loggedout!")
        }))
        
        self.present(ConfirmAlert, animated: true, completion: nil)
    }

    // MARK: - Filter Actions
    /// Triggered when the filter button is tapped. Displays the date filter options.
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        showDateFilterOptions()
    }
}

// MARK: - UITableViewDataSource
extension AdminHomeViewController: UITableViewDataSource {
    /// Returns the number of rows in the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredEvents.count : events.count
    }

    /// Configures and returns a cell for the table view at a given index path.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let event = events[indexPath.row]
        populateEventCell(cell: cell, with: event)
        return cell
    }

}

// MARK: - UITableViewDelegate
extension AdminHomeViewController: UITableViewDelegate {
    // Add delegate methods if needed (e.g., for row selection).
}

// MARK: - UISearchBarDelegate
extension AdminHomeViewController: UISearchBarDelegate {
    /// Updates the filtered events as the user types in the search bar.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resetFilter()
        } else {
            isSearching = true
            filteredEvents = events.filter { event in
                (event["Name"] as? String)?.lowercased().contains(searchText.lowercased()) ?? false
            }
            tableView.reloadData()
        }
    }

    /// Resets the search when the cancel button is clicked.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        resetFilter()
        searchBar.resignFirstResponder()
    }
}

// MARK: - Cell Population
extension AdminHomeViewController {
    /// Populates a table view cell with event data.
    func populateEventCell(cell: UITableViewCell, with event: [String: Any]) {
        if let imageView = cell.viewWithTag(1) as? UIImageView,
           let imageUrlString = event["Image"] as? String,
           let imageUrl = URL(string: imageUrlString) {
            loadImage(into: imageView, from: imageUrl)
        }

        (cell.viewWithTag(2) as? UILabel)?.text = event["Name"] as? String
        (cell.viewWithTag(3) as? UILabel)?.text = event["Date"] as? String
        (cell.viewWithTag(4) as? UILabel)?.text = event["Description"] as? String

        if let stackView = cell.viewWithTag(5) as? UIStackView {
            populateCategories(stackView: stackView, categories: event["Categories"] as? [String])
        }
    }

    /// Loads an image asynchronously into an image view.
    private func loadImage(into imageView: UIImageView, from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }

    /// Populates a stack view with category labels.
    private func populateCategories(stackView: UIStackView, categories: [String]?) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let labels = categories?.map { createCategoryLabel(for: $0) } ?? [createCategoryLabel(for: "No Categories")]
        labels.forEach { stackView.addArrangedSubview($0) }
    }

    /// Creates a label for a given category.
    private func createCategoryLabel(for category: String) -> UILabel {
        let label = UILabel()
        label.text = category
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        return label
    }
}

// MARK: - Cog Icon Actions
extension AdminHomeViewController {
    /// Triggered when the cog icon is tapped. Displays options for managing the event.
    @IBAction func cogIconTapped(_ sender: UIButton) {
        // Get the point where the button was tapped
        let point = sender.convert(CGPoint.zero, to: tableView)

        // Find the indexPath of the tapped cell
        if let indexPath = tableView.indexPathForRow(at: point) {
            // Show event options for the tapped event
            showOptions(for: indexPath)
        }
    }

    /// Displays an action sheet with options for the event at the specified index path.
    private func showOptions(for indexPath: IndexPath) {
        let event = isSearching ? filteredEvents[indexPath.row] : events[indexPath.row]

        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)

        // Add an option to edit categories
        alert.addAction(UIAlertAction(title: "Edit Categories", style: .default, handler: { _ in
            self.showEditCategoriesAlert(for: event, at: indexPath)
        }))

        // Add an option to remove the event
        alert.addAction(UIAlertAction(title: "Remove Post", style: .destructive, handler: { _ in
            self.confirmDeletion(for: event, at: indexPath)
        }))

        // Add a cancel option
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present the action sheet
        present(alert, animated: true, completion: nil)
    }
    /// Displays an alert to edit categories for the specified event.
    private func showEditCategoriesAlert(for event: [String: Any], at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Categories", message: "Enter new categories, separated by commas.", preferredStyle: .alert)

        // Add a text field pre-filled with current categories
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

        // Cancel editing
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    /// Updates the categories for the specified event in Firebase and locally.
    private func updateCategories(for event: [String: Any], with newCategories: [String], at indexPath: IndexPath) {
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
                print("Categories updated successfully.")
                if self.isSearching {
                    self.filteredEvents[indexPath.row]["Categories"] = sanitizedCategories
                } else {
                    self.events[indexPath.row]["Categories"] = sanitizedCategories
                }
                self.tableView.reloadData()
            }
        }
    }

    /// Displays a confirmation alert before deleting an event.
    private func confirmDeletion(for event: [String: Any], at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Are you sure?", message: "This action cannot be undone.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deletePost(event: event, at: indexPath)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    /// Deletes the specified event from Firebase and removes it locally.
    private func deletePost(event: [String: Any], at indexPath: IndexPath) {
        guard let eventName = event["Name"] as? String else {
            print("Event name not found.")
            return
        }

        let ref = Database.database().reference()
        ref.child("Events").child(eventName).removeValue { error, _ in
            if let error = error {
                print("Error deleting post: \(error.localizedDescription)")
            } else {
                print("Post deleted successfully.")
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



// MARK: - Filtering and Reset
extension AdminHomeViewController {
    /// Displays a date picker alert for filtering events.
    func showDateFilterOptions() {
        let alert = UIAlertController(title: "Filter Events by Date", message: nil, preferredStyle: .alert)

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "en_GB")

        alert.view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 10),
            datePicker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -10),
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50),
            datePicker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -60),
        ])

        alert.addAction(UIAlertAction(title: "Filter", style: .default) { _ in
            self.filterEventsByDate(datePicker.date)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.resetFilter()
        })

        let heightConstraint = NSLayoutConstraint(item: alert.view!,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 300)
        alert.view.addConstraint(heightConstraint)
        present(alert, animated: true)
    }

    /// Resets the filter and displays all events.
    func resetFilter() {
        isSearching = false
        filteredEvents = []
        tableView.reloadData()
    }

    /// Filters events based on the selected date and sorts them.
    func filterEventsByDate(_ selectedDate: Date) {
        filteredEvents = events.filter { event in
            guard let eventDateString = event["Date"] as? String,
                  let eventDate = parseDate(from: eventDateString, format: "dd-MM-yyyy") else {
                return false
            }
            return eventDate >= selectedDate
        }.sorted {
            compareDates($0["Date"] as? String, $1["Date"] as? String)
        }

        isSearching = true
        tableView.reloadData()
    }

    /// Parses a date string into a Date object.
    private func parseDate(from dateString: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: dateString)
    }

    /// Compares two date strings and returns true if the first is earlier.
    private func compareDates(_ date1String: String?, _ date2String: String?) -> Bool {
        guard let date1 = parseDate(from: date1String ?? "", format: "dd-MM-yyyy"),
              let date2 = parseDate(from: date2String ?? "", format: "dd-MM-yyyy") else { return false }
        return date1 < date2
    }
    
    
    
}


