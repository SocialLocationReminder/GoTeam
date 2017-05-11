import UIKit
import MBProgressHUD

class LabelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,
    LabelTableViewCellDelegate{

    @IBOutlet weak var labelSearchBar: UISearchBar!
    @IBOutlet weak var labelsTableView: UITableView!

    // labels and filtered labels
    var labels : [Labels]?
    var filteredLabels : [Labels]?
    var currentCellIndexPath: IndexPath?
    
    // application layer
    let labelManager = LabelManager()
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        }
        
        self.labelsTableView.reloadData()
    }
    
    @IBAction func doneDeleteUnwindToLabelsViewControllerSegue(_ segue : UIStoryboardSegue){
        let editLabelVC = segue.source as! EditLabelViewController
        let label = editLabelVC.label
        labelManager.deleteLabel(label: label!)
        self.labelsTableView.reloadData()
    }
    
    @IBAction func doneEditUnwindToLabelsViewControllerSegue(_ segue : UIStoryboardSegue){
        let editLabelVC = segue.source as! EditLabelViewController
        let label = editLabelVC.label
        if let newLabelName = editLabelVC.labelNameField.text {
            label?.labelName = newLabelName
            labelManager.updateLable(label: label!)
        }
        self.labelsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editLabelSegue" {
            let navigationController = segue.destination as! UINavigationController
            let editLabelViewController = navigationController.viewControllers[0] as! EditLabelViewController
            let label = self.labels?[(self.currentCellIndexPath?.row)!]
            editLabelViewController.label = label
        }
        else if segue.identifier == "filterTasksSegue" {
            let tabBarController = segue.destination as! UITabBarController
            let navigationController = tabBarController.customizableViewControllers?[0] as! UINavigationController
            let tasksViewController = navigationController.viewControllers[0] as! TasksViewController
            if self.currentCellIndexPath != nil{
                let label = self.labels?[(self.currentCellIndexPath?.row)!]
                var selectedLabelName = label?.labelName
                print (selectedLabelName!)
                tasksViewController.searchBar?.text = selectedLabelName!
                tasksViewController.searchKey = selectedLabelName!
                print (tasksViewController.searchBar?.text)
            }
        }
    }
    
    func editButtonAction(cell: LabelTableViewCell) {
        let indexPath = self.labelsTableView.indexPath(for: cell)
        self.currentCellIndexPath = indexPath!
    }
    
    func filterTasksForSelectedLabelAction(cell: LabelTableViewCell){
        let indexPath = self.labelsTableView.indexPath(for: cell)
        self.currentCellIndexPath = indexPath!
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
//        tabBarController.selectedIndex = 0
//        let tasksViewController = storyBoard.instantiateViewController(withIdentifier: "TasksViewController") as! TasksViewController
//        let label = self.labels?[(self.currentCellIndexPath?.row)!]
//        labelManager.selectedLabel = label
//        self.present(tabBarController, animated: true, completion: nil)
    }
    
    func deleteLabelCell(sender: LabelTableViewCell) {
        labelManager.deleteLabel(label: sender.label!)
        self.filteredLabels = self.filteredLabels?.filter() { $0 !== sender.label }
        self.labelsTableView.reloadData()
    }
    
    func fetchLabels() {
        self.filteredLabels = [Labels]()
        self.labels = [Labels]()
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
        if((self.filteredLabels?.count)! > 0){
            cell.labelName.text = filteredLabels?[indexPath.row].labelName
            cell.label = filteredLabels?[indexPath.row]
            cell.delegate = self as! LabelTableViewCellDelegate
        }
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
