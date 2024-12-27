import UIKit
import FirebaseDatabase

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    var searchQuery: String?
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
        
        if let query = searchQuery {
            populateEvents(query: query)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count // Display filtered results
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            fatalError("Unable to dequeue TableViewCell")
        }
        cell.configure(with: filteredResults[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedApp = filteredResults[indexPath.row]
        print("Selected app: \(selectedApp.title)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
                       let location = eventDetails["Location"] as? String,let rating = eventDetails["Rating"] as? Int {
                        
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
                                    price: 3.99,
                                    color: img,
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
    
    @objc func showFilterPopup() {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        let navController = UINavigationController(rootViewController: filterVC)
        present(navController, animated: true, completion: nil)
    }
}

extension SearchViewController: FilterViewControllerDelegate {
    func applyFilters(categories: [String], priceRange: ClosedRange<Float>, rating: Int, popularity: String) {
        print("Filters received in SearchViewController:")
        print("Categories: \(categories)")
        print("Price Range: \(priceRange)")
        print("Rating: \(rating)")
        print("Popularity: \(popularity)")
        
        // Apply the filters to the search results
        filteredResults = searchResults.filter { app in
            guard let price = app.price, let rating2 = app.rating else {
                return false // Exclude items with missing price or rating
            }
            let matchesCategory = categories.isEmpty || app.eventcategories.contains(where: categories.contains)
            let matchesPrice = priceRange.contains(Float(price))
            let matchesRating = rating2 >= rating
            return matchesCategory && matchesPrice && matchesRating
        }
        
        // Reload the table view with filtered results
        tableView.reloadData()
    }
}
