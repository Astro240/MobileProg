import Foundation
import UIKit

extension UIView {
    
    public func setTwoGradient(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
