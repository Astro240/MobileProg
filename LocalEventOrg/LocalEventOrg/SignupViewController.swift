import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignupViewController: UIViewController {

    // UI outlets for the sign-up form fields
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var Gender: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Gradient background setup
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.systemCyan.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    // Action for the Sign Up button
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let name = userName.text!
        let email = Email.text!
        let firstname = firstName.text!
        let lastname = lastName.text!
        let dateofbirth = dateOfBirth.text!
        let gender = Gender.text!
        let pass = password.text!
        let conpass = confirmPassword.text!
        
        // Check if all fields are filled in
        if name.isEmpty || email.isEmpty || firstname.isEmpty || lastname.isEmpty || dateofbirth.isEmpty || gender.isEmpty || pass.isEmpty || conpass.isEmpty {
            showAlertWithOk(title: "Error", message: "Please fill in all the fields!", okAction: nil)
        } else if pass != conpass {
            // Ensure passwords match
            showAlertWithOk(title: "Error", message: "Passwords do not match!", okAction: nil)
        } else {
            
            // Create Firebase Auth user
            Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                
                if error == nil {
                    
                    // User signed up successfully, now create the account in the Realtime Database
                    self.createUserInDatabase(userId: authResult!.user.uid, email: email, firstName: firstname, lastName: lastname, dateOfBirth: dateofbirth, gender: gender, userName: name, password: pass)
                    
                } else {
                    self.showAlertWithOk(title: "Error", message: error!.localizedDescription, okAction: nil)
                }
            }
        }
    }
    
    // Function to create user in Firebase Realtime Database
    func createUserInDatabase(userId: String, email: String, firstName: String, lastName: String, dateOfBirth: String, gender: String, userName: String, password: String) {
        
        // Set default interests and notifications (as per your JSON structure)
        let userDict: [String: Any] = [
            "Date of Birth": dateOfBirth,
            "Email": email,
            "First Name": firstName,
            "Interest1": false,
            "Interest2": false,
            "Interest3": false,
            "Interest4": false,
            "Interest5": false,
            "Interest6": false,
            "Interest7": false,
            "Interest8": false,
            "Interest9": false,
            "Last Name": lastName,
            "Notification1": false,
            "Notification2": false,
            "Notification3": false,
            "Notification4": false,
            "Notification5": false,
            "Notification6": false,
            "Password": password,
            "Role": "User",  // You can adjust the role accordingly
            "User name": userName,
            "gender": gender
        ]
        
        // Reference to the database
        let ref = Database.database().reference().child("Users").child(userId)
        
        // Create the user in Realtime Database
        ref.setValue(userDict) { error, _ in
            if let error = error {
                self.showAlertWithOk(title: "Error", message: "Failed to save user data: \(error.localizedDescription)", okAction: nil)
            } else {
                // Data saved successfully, now proceed to the next screen
                SceneDelegate.showInterests()
            }
        }
    }
}
