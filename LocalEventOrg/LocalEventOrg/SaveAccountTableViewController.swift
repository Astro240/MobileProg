import UIKit

class SaveAccountTableViewController: UITableViewController {

    @IBOutlet weak var SaveButton: UIButton!
    
    var data = ["Item 1", "Item 2", "Item 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SaveButton.addTarget(self, action: #selector(showSaveAlert), for: .touchUpInside)
    }
    
    @objc func showSaveAlert() {
        let saveConfirmAlert = UIAlertController(title: "Save", message: "Would you like to save the changes made?", preferredStyle: .alert)
        saveConfirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        saveConfirmAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            //Write code to save here
            print("Changes saved!")
        }))
        
        self.present(saveConfirmAlert, animated: true, completion: nil)
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
}
