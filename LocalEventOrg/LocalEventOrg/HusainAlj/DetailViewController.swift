import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var activityLabel: UILabel!
    var activityText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        activityLabel.text = activityText
    }
}
