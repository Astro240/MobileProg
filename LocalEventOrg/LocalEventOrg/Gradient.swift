//
//  Gradient.swift
//  LocalEventOrg
//
//  Created by BP-36-201-05 on 05/12/2024.
//

import UIKit

class Gradient: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemCyan.cgColor]
        view.layer.addSublayer(gradientLayer)
    }
}
