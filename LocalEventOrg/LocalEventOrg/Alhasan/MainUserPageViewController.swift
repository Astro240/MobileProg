import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MainUserPageViewController: UIViewController {

    @IBOutlet weak var SecondView: UIView!
    @IBOutlet weak var ShowName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting gradient background for the second view
        SecondView.setTwoGradient(colorOne: UIColor.white, colorTwo: UIColor.systemCyan)
        
        // Load user data when the view is loaded (you can pass the actual user ID dynamically)
        if let currentUserID = Auth.auth().currentUser?.uid {
            loadUserData(userID: currentUserID)
        }
    }

    // Function to load user data from Firebase Realtime Database
    func loadUserData(userID: String) {
        let ref = Database.database().reference().child("Users").child(userID)
        
        // Listen for real-time updates to the user data
        ref.observe(.value, with: { snapshot in
            // Makes sure the data exists
            guard let userDict = snapshot.value as? [String: Any] else {
                print("No data found for the user.")
                return
            }
            
            // Extract the username and update the label
            if let username = userDict["User name"] as? String {
                self.ShowName.text = username
            }
        }) { error in
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }
}
