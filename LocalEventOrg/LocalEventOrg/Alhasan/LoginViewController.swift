import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gradient Background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.systemCyan.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        guard let email = Email.text, !email.isEmpty,
              let password = password.text, !password.isEmpty else {
            print("Error: Email/Password can't be empty!")
            showAlertWithOk(title: "Login Error", message: "Please enter valid email/password", okAction: nil)
            return
        }
        
        // Firebase Auth: Sign In
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Error during login: \(error.localizedDescription)")
                self?.showAlertWithOk(title: "Login Error", message: error.localizedDescription, okAction: nil)
                return
            }
            
            guard let userId = Auth.auth().currentUser?.uid else {
                self?.showAlertWithOk(title: "Login Error", message: "Failed to retrieve user information.", okAction: nil)
                return
            }
            
            // Firebase Database: Fetch Role
            let ref = Database.database().reference()
            ref.child("Users").child(userId).observeSingleEvent(of: .value) { snapshot in
                guard let userData = snapshot.value as? [String: Any],
                      let roleName = userData["Role"] as? String else {
                    self?.showAlertWithOk(title: "Login Error", message: "Unable to fetch user role.", okAction: nil)
                    return
                }
                
                // Navigate based on Role
                if roleName == "User" {
                    print("Logged in Successfully as User!")
                    SceneDelegate.showHome() // Make sure this method is implemented in SceneDelegate
                } else if roleName == "Organizer" {
                    print("Logged in Successfully as Organizer!")
                    SceneDelegate.showEvHome() // Ensure this method exists in SceneDelegate
                } else if roleName == "Administrator"{
                    SceneDelegate.showAdminHome() // Ensure this method exists in SceneDelegate
                }
            } withCancel: { error in
                print("Database error: \(error.localizedDescription)")
                self?.showAlertWithOk(title: "Error", message: "Failed to fetch user data.", okAction: nil)
            }
        }
    }
}

// MARK: - Extension for Alerts
extension UIViewController {
    func showAlertWithOk(title: String, message: String, okAction: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: okAction))
        self.present(alert, animated: true)
    }
}
