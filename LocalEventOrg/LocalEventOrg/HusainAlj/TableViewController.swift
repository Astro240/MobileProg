import UIKit
import FirebaseAuth
import FirebaseAnalytics
import FirebaseDatabase
import Cloudinary

class TableViewController: UITableViewController {

    var activities = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Register the table view cell class and its reuse identifier
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ActivityCell")

        // Fetch data from Firebase
        fetchActivitiesFromFirebase()

        // Example usage of Cloudinary
        let config = CLDConfiguration(cloudName: "your_cloud_name", secure: true)
        let cloudinary = CLDCloudinary(configuration: config)
        print(cloudinary)
    }

    // MARK: - Firebase

    func fetchActivitiesFromFirebase() {
        let ref = Database.database().reference()
        ref.child("activities").observeSingleEvent(of: .value, with: { snapshot in
            if let activitiesDict = snapshot.value as? [String: Any] {
                for (_, value) in activitiesDict {
                    if let activity = value as? String {
                        self.activities.append(activity)
                    }
                }
                self.tableView.reloadData()
            }
        }) { error in
            print("Error fetching data: \(error.localizedDescription)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
        cell.textLabel?.text = activities[indexPath.row]
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: \(activities[indexPath.row])")
        // Deselect the row after selection
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let detailVC = segue.destination as! DetailViewController
                detailVC.activityText = activities[indexPath.row]
            }
        }
    }

}

