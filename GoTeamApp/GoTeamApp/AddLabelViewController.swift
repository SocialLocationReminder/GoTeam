import UIKit

class AddLabelViewController: UIViewController {

    @IBOutlet weak var newLabelTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newLabelTextField.text = ""
        newLabelTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
