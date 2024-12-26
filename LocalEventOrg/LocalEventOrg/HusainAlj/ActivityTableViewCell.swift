import UIKit
import FirebaseAuth
import FirebaseAnalytics
import FirebaseDatabase
import Cloudinary

class ActivityTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var activityImageView: UIImageView!
    
 

    class MyActivityViewController: UITableViewController {

        var activities = [String]()

        override func viewDidLoad() {
            super.viewDidLoad()
            self.tableView.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityCell")

            // Fetch data from Firebase
            fetchActivitiesFromFirebase()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityTableViewCell

            // Configure the cell with an image
            let imageName = activities[indexPath.row]
            cell.activityImageView.image = UIImage(named: imageName)

            return cell
        }

        // MARK: - Table view delegate

        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Image clicked: \(activities[indexPath.row])")
            // No further action needed for now
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    
    
    
    
}
