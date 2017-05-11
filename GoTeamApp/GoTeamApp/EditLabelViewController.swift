import UIKit

class EditLabelViewController: UIViewController {
    
    @IBOutlet weak var labelNameField: UITextField!
    var label: Labels?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelNameField.text = label?.labelName!
        labelNameField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
