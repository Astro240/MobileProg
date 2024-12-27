import UIKit

/// Shows two sections in a single table:
///  - Section 0: "Upcoming Events"
///  - Section 1: "Past Events"
///
/// Uses a single UITableView in the storyboard with prototype cells
/// that have the reuse identifiers "ActivityCell" and "ActivityCell1".
class EventsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var upcomingEvents: [Event] = []
    private var pastEvents: [Event] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show a custom title
        title = "My Activity"
        
        // Self-sizing cells
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        
        // Connect the table's delegate & data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Load upcoming & past events from the manager
        upcomingEvents = EventsDataManager.shared.getUpcomingEvents()
        pastEvents = EventsDataManager.shared.getPastEvents()
        
        // Display them
        tableView.reloadData()
        
        // (iOS 15+) remove default spacing above the first section
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
}

// MARK: - UITableViewDataSource
extension EventsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Now we have 2 sections: 0 for Upcoming, 1 for Past
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return upcomingEvents.count
        case 1:
            return pastEvents.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "ActivityCell",
                for: indexPath
            ) as? ActivityTableViewCell else {
                return UITableViewCell(style: .default, reuseIdentifier: "FallbackCell")
            }
            
            let event = upcomingEvents[indexPath.row]
            cell.configure(with: event)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "ActivityCell1",
                for: indexPath
            ) as? ActivityTableViewCell else {
                return UITableViewCell(style: .default, reuseIdentifier: "FallbackCell")
            }
            
            let event = pastEvents[indexPath.row]
            cell.configure(with: event)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension EventsViewController: UITableViewDelegate {
    
    /// Return a custom header view. Different text per section.
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 31.2) // 30% bigger than 24
        
        // Section 0 -> "Upcoming Events"
        // Section 1 -> "Past Events"
        switch section {
        case 0:
            titleLabel.text = "Upcoming Events"
        case 1:
            titleLabel.text = "Past Events"
        default:
            titleLabel.text = "Other"
        }
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
    
    /// Fixed height for the header (50 points).
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    /// Add a line between sections.
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .lightGray
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1 // Height of the line
    }
    
    /// Optional row selection handling
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("Tapped upcoming event: \(upcomingEvents[indexPath.row].name)")
        } else {
            print("Tapped past event: \(pastEvents[indexPath.row].name)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
