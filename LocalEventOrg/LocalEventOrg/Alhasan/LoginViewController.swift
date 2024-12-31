import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logintitle: UILabel!
    @IBOutlet weak var emailtitle: UILabel!
    @IBOutlet weak var passwordtitle: UILabel!
    @IBOutlet weak var donthaveaccount: UILabel!
    @IBOutlet weak var signup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.systemCyan.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Add Auto Layout constraints to UI elements
        setupConstraints()
    }
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        let email = Email.text!
        let password = password.text!
        
        if email.isEmpty || password.isEmpty {
            print("Error Email/Password can't be empty!")
            showAlertWithOk(title: "Login Error", message: "Please enter valid email/password", okAction: nil)
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if error == nil {
                    print("Logged in Successfully!")
                    SceneDelegate.showHome()
                } else {
                    self.showAlertWithOk(title: "Login Error", message: error!.localizedDescription, okAction: nil)
                }
            }
        }
    }
    
    private func setupConstraints() {
        // Disable autoresizing mask for all elements
        [logo, logintitle, emailtitle, Email, passwordtitle, password, logInButton, donthaveaccount, signup].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Add constraints for the logo
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logo.widthAnchor.constraint(equalToConstant: 100),
            logo.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Add constraints for the login title
        NSLayoutConstraint.activate([
            logintitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logintitle.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 20)
        ])
        
        // Add constraints for the email title
        NSLayoutConstraint.activate([
            emailtitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailtitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailtitle.topAnchor.constraint(equalTo: logintitle.bottomAnchor, constant: 20)
        ])
        
        // Add constraints for the email field
        NSLayoutConstraint.activate([
            Email.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            Email.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            Email.topAnchor.constraint(equalTo: emailtitle.bottomAnchor, constant: 8),
            Email.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Add constraints for the password title
        NSLayoutConstraint.activate([
            passwordtitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordtitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordtitle.topAnchor.constraint(equalTo: Email.bottomAnchor, constant: 20)
        ])
        
        // Add constraints for the password field
        NSLayoutConstraint.activate([
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            password.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            password.topAnchor.constraint(equalTo: passwordtitle.bottomAnchor, constant: 8),
            password.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Add constraints for the login button
        NSLayoutConstraint.activate([
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logInButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20),
            logInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add constraints for "Don't have an account?" label
        NSLayoutConstraint.activate([
            donthaveaccount.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            donthaveaccount.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 20)
        ])
        
        // Add constraints for the Sign Up button
        NSLayoutConstraint.activate([
            signup.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signup.topAnchor.constraint(equalTo: donthaveaccount.bottomAnchor, constant: 8)
        ])
    }
}

extension UIViewController {
    func showAlertWithOk(title: String, message: String, okAction: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: okAction))
        self.present(alert, animated: true)
    }
}
