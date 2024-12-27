import UIKit
import FirebaseDatabase

class SearchViewController: UITableViewController,UISearchBarDelegate {
    
    var searchQuery: String?
    var searchResults: [App] = [] // Store search results
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
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.rowHeight = 150 // Updated row height
        tableView.estimatedRowHeight = 150
        tableView.delegate = self  // Set the delegate
        
        if let query = searchQuery {
            populateEvents(query: query)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            fatalError("Unable to dequeue EventCell")
        }
        cell.configure(with: searchResults[indexPath.row])
        return cell
    }
    
    // Implement didSelectRowAt to handle cell clicks
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedApp = searchResults[indexPath.row]
        
        // You can handle the selected app here
        // For example, navigate to a new view controller that shows more details
        print("Selected app: \(selectedApp.title)")
        
        // Example of navigation:
        // let detailViewController = DetailViewController()
        // detailViewController.appDetails = selectedApp
        // navigationController?.pushViewController(detailViewController, animated: true)
        
        // Optionally, you can also deselect the row after it's tapped
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
                       let desc = eventDetails["Description"] as? String, let location = eventDetails["Location"] as? String {
                        
                        // Fetch and process image
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
                                    location: location
                                )
                                
                                // Append search result
                                self.searchResults.append(app)
                                
                                // Reload table view on main thread
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
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }
}
