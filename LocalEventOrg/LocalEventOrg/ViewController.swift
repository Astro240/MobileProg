//
//  ViewController.swift
//  LocalEventOrg
//
//  Created by BP-36-201-06 on 25/11/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var SecondView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SecondView.setTwoGradient(colorOne: UIColor.white, colorTwo: UIColor.systemCyan);
        // Do any additional setup after loading the view.
    }
    
   
}

