//
//  shadowViewController.swift
//  LocalEventOrg
//
//  Created by BP-36-201-05 on 22/12/2024.
//

import UIKit

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
    
    var Button1isActive:Bool = false
    var Button2isActive:Bool = false
    var Button3isActive:Bool = false
    var Button4isActive:Bool = false
    var Button5isActive:Bool = false
    var Button6isActive:Bool = false
    var Button7isActive:Bool = false
    var Button8isActive:Bool = false
    var Button9isActive:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Button1.applyDesign()
        Button2.applyDesign()
        Button3.applyDesign()
        Button4.applyDesign()
        Button5.applyDesign()
        Button6.applyDesign()
        Button7.applyDesign()
        Button8.applyDesign()
        Button9.applyDesign()
        
    }
    @IBAction func Button1Click(_ sender: Any) {
        if(!Button1isActive){
            Button1.altDesign()
            Button1isActive = true
        }
        else{
            Button1.applyDesign()
            Button1isActive = false
        }
    }
    
    @IBAction func Button2Click(_ sender: Any) {
        if(!Button2isActive){
            Button2.altDesign()
            Button2isActive = true
        }
        else{
            Button2.applyDesign()
            Button2isActive = false
        }
    }
    
    @IBAction func Button3Click(_ sender: Any) {
        if(!Button3isActive){
            Button3.altDesign()
            Button3isActive = true
        }
        else{
            Button3.applyDesign()
            Button3isActive = false
        }
    }
    
    @IBAction func Button4Click(_ sender: Any) {
        if(!Button4isActive){
            Button4.altDesign()
            Button4isActive = true
        }
        else{
            Button4.applyDesign()
            Button4isActive = false
        }
    }
    
    @IBAction func Button5Click(_ sender: Any) {
        if(!Button5isActive){
            Button5.altDesign()
            Button5isActive = true
        }
        else{
            Button5.applyDesign()
            Button5isActive = false
        }
    }
    
    @IBAction func Button6Click(_ sender: Any) {
        if(!Button6isActive){
            Button6.altDesign()
            Button6isActive = true
        }
        else{
            Button6.applyDesign()
            Button6isActive = false
        }
    }
    
    @IBAction func Button7Click(_ sender: Any) {
        if(!Button7isActive){
            Button7.altDesign()
            Button7isActive = true
        }
        else{
            Button7.applyDesign()
            Button7isActive = false
        }
    }
    
    @IBAction func Button8Click(_ sender: Any) {
        if(!Button8isActive){
            Button8.altDesign()
            Button8isActive = true
        }
        else{
            Button8.applyDesign()
            Button8isActive = false
        }
    }
    
    @IBAction func Button9Click(_ sender: Any) {
        if(!Button9isActive){
            Button9.altDesign()
            Button9isActive = true
        }
        else{
            Button9.applyDesign()
            Button9isActive = false
        }
    }
    
    
}
extension UIButton{
    func applyDesign(){
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    func altDesign(){
        self.layer.shadowColor = UIColor.cyan.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
     
}
