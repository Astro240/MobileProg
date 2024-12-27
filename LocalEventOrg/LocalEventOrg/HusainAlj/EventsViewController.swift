import UIKit

/// Manages the "Events" page, showing a single section of "Upcoming Events."
/// Everything is laid out in code, except the bare-minimum TableView in the Storyboard.
class EventsViewController: UIViewController {
    
    // MARK: - Outlets
    
    /// Make sure to connect this in Storyboard to the TableView you dragged onto the VC.
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var upcomingEvents: [Event] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Optional: set the navigation bar title
        title = "Events"
        
        // If you rely on self-sizing cells:
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        
        // If you removed the prototype cell from storyboard, you must register in code:
        // tableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: "ActivityCell")
        
        // Assign the table's delegate & data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Load data from the manager
        upcomingEvents = EventsDataManager.shared.getUpcomingEvents()
        
        // Reload table to show data
        tableView.reloadData()
        
        // (iOS 15+ only) remove default spacing above first section header
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
}

// MARK: - UITableViewDataSource
extension EventsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Only 1 section for "Upcoming Events"
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingEvents.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ActivityCell",
            for: indexPath
        ) as? ActivityTableViewCell else {
            // If cast fails, return a simple cell.
            return UITableViewCell(style: .default, reuseIdentifier: "FallbackCell")
        }
        
        let event = upcomingEvents[indexPath.row]
        cell.configure(with: event)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension EventsViewController: UITableViewDelegate {
    
    /// Create a custom header for the single section with a bold, large title.
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        // Container for the title label
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        
        // Label
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Upcoming Events"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
    
    /// Fixed height for the header
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    /// Handle row selection if needed
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let event = upcomingEvents[indexPath.row]
        print("Tapped event: \(event.name)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
