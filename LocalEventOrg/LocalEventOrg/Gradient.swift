import UIKit

class Gradient: UIViewController {

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
}
