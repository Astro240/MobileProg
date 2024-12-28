//
//  LogOutTableViewController.swift
//  LocalEventOrg
//
//  Created by BP-36-201-05 on 24/12/2024.
//

import UIKit
import FirebaseAuth

class LogOutTableViewController: UITableViewController {

    @IBOutlet weak var logOutButton: UIButton!
    
    var data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.addTarget(self, action: #selector(showLogOutAlert), for: .touchUpInside)
        
    }

    @objc func showLogOutAlert() {
        let ConfirmAlert = UIAlertController(title: "Save", message: "Would you like to Logout?", preferredStyle: .alert)
        ConfirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ConfirmAlert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                SceneDelegate.showLogin()
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
            
            print("User Loggedout!")
        }))
        
        self.present(ConfirmAlert, animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

}
