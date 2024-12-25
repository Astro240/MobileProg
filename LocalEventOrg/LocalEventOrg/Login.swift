import UIKit
import FirebaseAuth

class login: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        // Define the colors for the gradient: cyan to white
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.systemCyan.cgColor ]

        // Optionally, you can set the locations and direction of the gradient
        gradientLayer.locations = [0.5, 1.1]  // Default (left to right)

        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func login(){
        
        if self.email.text == "" || self.pass.text == ""{
            let ConfirmAlert = UIAlertController(title: "Email/Password is empty", message: "Please insert some text into the text boxes", preferredStyle: .alert)
            ConfirmAlert.addAction(UIAlertAction(title: "Close", style: .cancel))
            
        }
        else{
            
            Auth.auth().signIn(withEmail: self.email.text!, password: self.pass.text!)
            
                
            
        }
    }
    
}
