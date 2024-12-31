import UIKit
import FirebaseDatabase

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    var searchQuery: String? // For search query passed from the home page (optional)
    var searchResults: [App] = [] // Store search results
    var filteredResults: [App] = [] // Store filtered results
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Search"
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Events"
        searchController.searchBar.delegate = self // Set the delegate to self to handle search events
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Add a filter button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Filter",
            style: .plain,
            target: self,
            action: #selector(showFilterPopup)
        )
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.rowHeight = 150
        tableView.estimatedRowHeight = 150
        
        // If there's a query passed to this page, populate events immediately
        if let query = searchQuery {
            populateEvents(query: query)
        }
    }
    
    // Handle the number of rows in the table view (display filtered results)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    // Handle how each cell is displayed in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            fatalError("Unable to dequeue TableViewCell")
        }
        cell.configure(with: filteredResults[indexPath.row])
        return cell
    }
    
    // Handle selection of a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedApp = filteredResults[indexPath.row]
        print("Selected app: \(selectedApp.title)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let eventViewController = EventViewController()
        eventViewController.App = selectedApp // Pass the App object to the EventViewController

        navigationController?.pushViewController(eventViewController, animated: true)
    }
    
    // Fetch events from Firebase and filter based on search query
    func populateEvents(query: String) {
        let ref = Database.database().reference()
        ref.child("Events").observeSingleEvent(of: .value, with: { snapshot in
            if let eventsDict = snapshot.value as? [String: Any] {
                for (_, eventData) in eventsDict {
                    if let eventDetails = eventData as? [String: Any],
                       let eventName = eventDetails["Name"] as? String,
                       let eventImageURL = eventDetails["Image"] as? String,
                       let categories = eventDetails["Categories"] as? [String],
                       let desc = eventDetails["Description"] as? String,
                       let location = eventDetails["Location"] as? String, let date = eventDetails["Date"] as? String,
                       let rating = eventDetails["Rating"] as? Int {

                        // Process tickets
                        var tickets: [String: Double] = [:]
                        if let ticketsData = eventDetails["Tickets"] as? [String: [String: Any]] {
                            for (_, ticketInfo) in ticketsData {
                                if let ticketName = ticketInfo["Name"] as? String,
                                   let ticketPrice = ticketInfo["Price"] as? Double {
                                    tickets[ticketName] = ticketPrice
                                }
                            }
                        }

                        self.loadImage(from: eventImageURL) { image in
                            guard let img = image else {
                                print("Failed to load image for event: \(eventName)")
                                return
                            }
                            if eventName.lowercased().contains(query.lowercased()) || categories.contains(where: { $0.lowercased().contains(query.lowercased()) }) {
                                let app = App(
                                    promotedHeadline: "",
                                    title: eventName,
                                    subtitle: "",
                                    price: tickets, // Replacing price with tickets
                                    color: img,
                                    date: date,
                                    desc: desc,
                                    eventcategories: categories,
                                    location: location,
                                    rating: rating
                                )
                                self.searchResults.append(app)
                                self.filteredResults = self.searchResults // Initialize filtered results
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            } else {
                print("No data found")
            }
        }, withCancel: { error in
            print("Error fetching data: \(error.localizedDescription)")
        })
    }

    
    // Load image asynchronously from a URL
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }
    
    // Handle search bar text changes (live filtering)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    // Handle search bar submit (search button pressed)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        self.searchResults = []
        // Perform the search when the user submits the search
        populateEvents(query: query)
        
        // Dismiss the keyboard after search
        searchBar.resignFirstResponder()
    }
    
    // Handle search bar cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // When the search is canceled, reset the filtered results
        filteredResults = searchResults
        tableView.reloadData()
    }
    
    // Show filter popup when the filter button is tapped
    @objc func showFilterPopup() {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        let navController = UINavigationController(rootViewController: filterVC)
        present(navController, animated: true, completion: nil)
    }
}

extension SearchViewController: FilterViewControllerDelegate {
    // Apply filters from the filter view controller
    func applyFilters(categories: [String], priceRange: ClosedRange<Float>, rating: Int) {
        print("Filters received in SearchViewController:")
        print("Categories: \(categories)")
        print("Price Range: \(priceRange)")
        print("Rating: \(rating)")
        
        // Apply the filters to the search results
        filteredResults = searchResults.filter { app in
            guard let rating2 = app.rating else {
                return false // Exclude items with missing price or rating
            }
            
            var matchesCategory = false
            if categories.contains("All") {
                matchesCategory = true
            } else {
                matchesCategory = categories.isEmpty || app.eventcategories.contains(where: categories.contains)
            }
            
//            let matchesPrice = priceRange.contains(Float(price))
            let matchesRating = rating2 >= rating
            return matchesCategory && matchesRating
        }
        
        // Reload the table view with filtered results
        tableView.reloadData()
    }
}
