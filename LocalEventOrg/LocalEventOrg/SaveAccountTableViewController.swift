import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SaveAccountTableViewController: UITableViewController {

    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    var data = ["Item 1", "Item 2", "Item 3"]
    
    // Current User ID (looks like XD LMAO)
    var currentUserID: String? = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load user data from Firebase when the view loads
        if let userID = currentUserID {
            loadUserData(userID: userID)
        } else {
            print("No user is logged in.")
        }
        
        SaveButton.addTarget(self, action: #selector(showSaveAlert), for: .touchUpInside)
    }
    
    // Function to load user data from Firebase and populate text fields
    func loadUserData(userID: String) {
        let ref = Database.database().reference().child("Users").child(userID)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let userDict = snapshot.value as? [String: Any] else {
                print("No data found for the user.")
                return
            }
            
            // Populate the text fields with the user data
            if let email = userDict["Email"] as? String {
                self.Email.text = email  // Email is shown but not editable
            }
            if let username = userDict["User name"] as? String {
                self.Username.text = username
            }
            if let password = userDict["Password"] as? String {
                self.Password.text = password
            }
        }) { error in
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }
    
    // Action when the "Save" button is pressed
    @objc func showSaveAlert() {
        let saveConfirmAlert = UIAlertController(title: "Save", message: "Would you like to save the changes made?", preferredStyle: .alert)
        
        saveConfirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        saveConfirmAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            // Save the updated data to Firebase
            if let userID = self.currentUserID {
                self.saveUserData(userID: userID)
            }
        }))
        
        self.present(saveConfirmAlert, animated: true, completion: nil)
    }
    
    // Function to save the updated user data to Firebase
    func saveUserData(userID: String) {
        let newUsername = Username.text ?? ""
        let newPassword = Password.text ?? ""
        
        // Validate input (You can add more validation as needed)
        if newUsername.isEmpty || newPassword.isEmpty {
            showAlert(title: "Error", message: "Username and password cannot be empty.")
            return
        }
        
        let ref = Database.database().reference().child("Users").child(userID)
        
        // Update the user's data
        let updatedData: [String: Any] = [
            "User name": newUsername,
            "Password": newPassword
        ]
        
        ref.updateChildValues(updatedData) { error, _ in
            if let error = error {
                self.showAlert(title: "Error", message: "Failed to save data: \(error.localizedDescription)")
            } else {
                self.showAlert(title: "Success", message: "Your changes have been saved.")
            }
        }
    }
    
    // Utility function to show an alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Account Details"
    }
}
