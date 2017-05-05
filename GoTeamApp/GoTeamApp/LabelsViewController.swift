import UIKit
import MBProgressHUD

class LabelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var labelSearchBar: UISearchBar!
    @IBOutlet weak var labelsTableView: UITableView!

    // labels and filtered labels
    var labels : [Labels]?
    var filteredLabels : [Labels]?
    
    // application layer
    let labelManager = LabelManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup table view
        labelsTableView.dataSource = self
        labelsTableView.delegate = self
        
        // setup auto row height
        labelsTableView.rowHeight = UITableViewAutomaticDimension
        
        // setup search bar
        labelSearchBar.delegate = self
        labelSearchBar.becomeFirstResponder()
        fetchLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLablesViewControllerSegue(_ segue : UIStoryboardSegue) {
        
    }
    
    @IBAction func doneUnwindToLablesViewControllerSegue(_ segue : UIStoryboardSegue) {
        let addLabelVC = segue.source as! AddLabelViewController
        let label = Labels()
        
        if let labelName = addLabelVC.newLabelTextField.text {
            label.labelName = labelName
            labelManager.add(label: label)
            fetchLabels()
        }
        self.labelsTableView.reloadData()
    }
    
    func fetchLabels() {
        self.labels = [Labels]()
        self.filteredLabels = [Labels]()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        labelSearchBar.text = ""
        labelManager.allLabels(fetch: true, success: { (receivedLabels) in

            DispatchQueue.main.async {
                hud.hide(animated: true)
                self.labels = receivedLabels
                self.filteredLabels = self.labels
                self.labelsTableView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                // @todo: show network error
                hud.hide(animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredLabels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = labelsTableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as! LabelTableViewCell
        cell.labelName.text = filteredLabels?[indexPath.row].labelName
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applyLabelFilter()
    }
    
    func applyLabelFilter() {
        guard var searchText = labelSearchBar.text else { return; }
        searchText = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if searchText.characters.count == 0 {
            filteredLabels = labels
            labelsTableView.reloadData()
            return;
        }
        
        filteredLabels = [Labels]()
        for label in self.labels!
        {
            if (label.labelName?.lowercased().contains(searchText.lowercased()))!
            {
                self.filteredLabels?.append(label)
            }
        }
        labelsTableView.reloadData()
    }
}
