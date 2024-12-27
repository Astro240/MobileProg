import UIKit
import FirebaseDatabase

class SearchViewController: UITableViewController {
    
    var searchQuery: String?
    var searchResults: [App] = [] // Store search results
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Search"
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.rowHeight = 150 // Updated row height
            tableView.estimatedRowHeight = 150
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
    
    func populateEvents(query: String) {
        let ref = Database.database().reference()
        ref.child("Events").observeSingleEvent(of: .value, with: { snapshot in
            if let eventsDict = snapshot.value as? [String: Any] {
                for (_, eventData) in eventsDict {
                    if let eventDetails = eventData as? [String: Any],
                       let eventName = eventDetails["Name"] as? String,
                       let eventImageURL = eventDetails["Image"] as? String,
                       let categories = eventDetails["Categories"] as? [String],
                       let desc = eventDetails["Description"] as? String {
                        
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
                                    eventcategories: categories
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
