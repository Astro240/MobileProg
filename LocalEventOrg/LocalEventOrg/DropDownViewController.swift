//
//  DropDownViewController.swift
//  LocalEventOrg
//
//  Created by BP-36-201-05 on 22/12/2024.
//

import UIKit

class DropDownViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var SendtoHnSButton: UIButton!
    
    var problemList = ["Report bug", "Inappropriete reviews", "problems found in the app", "Other"]
    
    var picker:UIPickerView!
    var textfield:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SendtoHnSButton.addTarget(self, action: #selector(showSaveAlert), for: .touchUpInside)
        
        let textfield = UITextField(frame: CGRect(x: 46, y: 150, width: 301, height: 50))
        textfield.placeholder = "Pick a problem"
        textfield.borderStyle = .roundedRect
        view.addSubview(textfield)
        self.textfield = textfield
        
        let picker = UIPickerView()
        picker.sizeToFit()
        picker.delegate = self
        picker.dataSource = self
        textfield.inputView = picker
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return problemList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return problemList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textfield.text = problemList[row]
    }
    
    @objc func showSaveAlert() {
        let saveConfirmAlert = UIAlertController(title: "Send Message", message: "Do you want to send this message?", preferredStyle: .alert)
        saveConfirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        saveConfirmAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (_) in
            //Write code to save here
            print("Message sent!")
        }))
        
        self.present(saveConfirmAlert, animated: true, completion: nil)
    }
}
