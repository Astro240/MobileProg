import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class shadowViewController: UIViewController {
    
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button4: UIButton!
    @IBOutlet weak var Button5: UIButton!
    @IBOutlet weak var Button6: UIButton!
    @IBOutlet weak var Button7: UIButton!
    @IBOutlet weak var Button8: UIButton!
    @IBOutlet weak var Button9: UIButton!
    
    @IBOutlet weak var NextButton: UIButton?
    
    var Button1isActive = false
    var Button2isActive = false
    var Button3isActive = false
    var Button4isActive = false
    var Button5isActive = false
    var Button6isActive = false
    var Button7isActive = false
    var Button8isActive = false
    var Button9isActive = false
    
    var userID: String {
        return Auth.auth().currentUser?.uid ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.systemCyan.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Apply custom design to buttons
        Button1.applyDesign()
        Button2.applyDesign()
        Button3.applyDesign()
        Button4.applyDesign()
        Button5.applyDesign()
        Button6.applyDesign()
        Button7.applyDesign()
        Button8.applyDesign()
        Button9.applyDesign()
        
        // Fetch current user interests from Firebase
        loadUserInterests()
        
        // Add target to NextButton for navigation if it exists
        NextButton?.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    // Fetch user interests from Firebase
    func loadUserInterests() {
        let ref = Database.database().reference().child("Users").child(userID)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let userDict = snapshot.value as? [String: Any] else { return }
            
            // Update the button states based on the values in Firebase
            if let interest1 = userDict["Interest1"] as? Bool {
                self.Button1isActive = interest1
                self.updateButtonState(for: "Interest1", isActive: interest1)
            }
            if let interest2 = userDict["Interest2"] as? Bool {
                self.Button2isActive = interest2
                self.updateButtonState(for: "Interest2", isActive: interest2)
            }
            if let interest3 = userDict["Interest3"] as? Bool {
                self.Button3isActive = interest3
                self.updateButtonState(for: "Interest3", isActive: interest3)
            }
            if let interest4 = userDict["Interest4"] as? Bool {
                self.Button4isActive = interest4
                self.updateButtonState(for: "Interest4", isActive: interest4)
            }
            if let interest5 = userDict["Interest5"] as? Bool {
                self.Button5isActive = interest5
                self.updateButtonState(for: "Interest5", isActive: interest5)
            }
            if let interest6 = userDict["Interest6"] as? Bool {
                self.Button6isActive = interest6
                self.updateButtonState(for: "Interest6", isActive: interest6)
            }
            if let interest7 = userDict["Interest7"] as? Bool {
                self.Button7isActive = interest7
                self.updateButtonState(for: "Interest7", isActive: interest7)
            }
            if let interest8 = userDict["Interest8"] as? Bool {
                self.Button8isActive = interest8
                self.updateButtonState(for: "Interest8", isActive: interest8)
            }
            if let interest9 = userDict["Interest9"] as? Bool {
                self.Button9isActive = interest9
                self.updateButtonState(for: "Interest9", isActive: interest9)
            }
        })
    }

    
    // Update the button's visual state
    func updateButtonState(for interestKey: String, isActive: Bool) {
        switch interestKey {
        case "Interest1":
            isActive ? Button1.altDesign() : Button1.applyDesign()
        case "Interest2":
            isActive ? Button2.altDesign() : Button2.applyDesign()
        case "Interest3":
            isActive ? Button3.altDesign() : Button3.applyDesign()
        case "Interest4":
            isActive ? Button4.altDesign() : Button4.applyDesign()
        case "Interest5":
            isActive ? Button5.altDesign() : Button5.applyDesign()
        case "Interest6":
            isActive ? Button6.altDesign() : Button6.applyDesign()
        case "Interest7":
            isActive ? Button7.altDesign() : Button7.applyDesign()
        case "Interest8":
            isActive ? Button8.altDesign() : Button8.applyDesign()
        case "Interest9":
            isActive ? Button9.altDesign() : Button9.applyDesign()
        default:
            break
        }
    }
    
    // Button click actions to toggle button states
    @IBAction func Button1Click(_ sender: Any) { toggleButtonState(button: Button1, isActive: &Button1isActive) }
    @IBAction func Button2Click(_ sender: Any) { toggleButtonState(button: Button2, isActive: &Button2isActive) }
    @IBAction func Button3Click(_ sender: Any) { toggleButtonState(button: Button3, isActive: &Button3isActive) }
    @IBAction func Button4Click(_ sender: Any) { toggleButtonState(button: Button4, isActive: &Button4isActive) }
    @IBAction func Button5Click(_ sender: Any) { toggleButtonState(button: Button5, isActive: &Button5isActive) }
    @IBAction func Button6Click(_ sender: Any) { toggleButtonState(button: Button6, isActive: &Button6isActive) }
    @IBAction func Button7Click(_ sender: Any) { toggleButtonState(button: Button7, isActive: &Button7isActive) }
    @IBAction func Button8Click(_ sender: Any) { toggleButtonState(button: Button8, isActive: &Button8isActive) }
    @IBAction func Button9Click(_ sender: Any) { toggleButtonState(button: Button9, isActive: &Button9isActive) }

    func toggleButtonState(button: UIButton, isActive: inout Bool) {
        if isActive {
            button.applyDesign()
        } else {
            button.altDesign()
        }
        isActive.toggle()
    }
    
    // Button being clicked augh
    @objc func nextButtonPressed(_ sender: Any) {
        let updatedInterests: [String: Bool] = [
            "Interest1": Button1isActive,
            "Interest2": Button2isActive,
            "Interest3": Button3isActive,
            "Interest4": Button4isActive,
            "Interest5": Button5isActive,
            "Interest6": Button6isActive,
            "Interest7": Button7isActive,
            "Interest8": Button8isActive,
            "Interest9": Button9isActive
        ]
        
        let ref = Database.database().reference().child("Users").child(self.userID)
        
        // Save the updated interest data to Firebase
        ref.updateChildValues(updatedInterests) { error, _ in
            if let error = error {
                print("Error saving interests: \(error.localizedDescription)")
            } else {
                print("Interests saved successfully!")
                // Optionally, you can navigate to another screen or perform other actions here
            }
        }
        // Move to next screeeen
        SceneDelegate.showHome()
    }
}

extension UIButton {
    func applyDesign() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    func altDesign() {
        self.layer.shadowColor = UIColor.cyan.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
