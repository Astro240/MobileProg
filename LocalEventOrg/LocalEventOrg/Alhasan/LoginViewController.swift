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
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.systemCyan.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        let email = Email.text!
        let password = password.text!
        
        if email.isEmpty || password.isEmpty{
            print("Error Email/Password can't be empty!")
            showAlertWithOk(title: "Login Error", message: "Please enter valid email/password", okAction: nil)
        }else{
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if error == nil {
                    print("logged in Successfully!")
                    SceneDelegate.showHome()
                }else{
                    self.showAlertWithOk(title: "Login Error", message: error!.localizedDescription, okAction: nil)
                }
            }
        }
    }
}
extension UIViewController {
    func showAlertWithOk(title: String, message: String, okAction:((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: okAction))
        self.present(alert, animated: true)
    }
}
