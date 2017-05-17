import UIKit
import MBProgressHUD

class LabelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,
    LabelTableViewCellDelegate{

    @IBOutlet weak var labelSearchBar: UISearchBar!
    @IBOutlet weak var labelsTableView: UITableView!

    @IBOutlet weak var addButton: UIButton!
    
    // labels and filtered labels
    var filteredLabels : [Labels]?
    var currentCellIndexPath: IndexPath?
    
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
        
        // setup tap gesture recognizer
        setupTapGestureRecognizer()
        
        // fetch labels
        fetchLabels()
        
        setupAddButton()
    }
    
    func setupAddButton() {
        addButton.layer.cornerRadius = 48.0 / 2.0
        // addButton.clipsToBounds = true
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 1.0;
        addButton.layer.shadowRadius = 2.0
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func unwindToLablesViewControllerSegue(_ segue : UIStoryboardSegue) {
        
    }
    
    func setupTapGestureRecognizer() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGR)
    }
    
    func viewTapped() {
        labelSearchBar.resignFirstResponder()
    }

    
    @IBAction func doneUnwindToLablesViewControllerSegue(_ segue : UIStoryboardSegue) {
        let addLabelVC = segue.source as! AddLabelViewController
        let label = Labels()
        
        if let labelName = addLabelVC.newLabelTextField.text {
            label.labelName = labelName
            labelManager.add(label: label)
            self.applyLabelFilter()
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Resources.Strings.Notifications.kLabelsUpdated)))
        }
        
        self.labelsTableView.reloadData()
    }
    
    @IBAction func doneDeleteUnwindToLabelsViewControllerSegue(_ segue : UIStoryboardSegue){
        let editLabelVC = segue.source as! EditLabelViewController
        let label = editLabelVC.label
        labelManager.deleteLabel(label: label!)
        self.applyLabelFilter()
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Resources.Strings.Notifications.kLabelsUpdated)))
    }
    
    @IBAction func doneEditUnwindToLabelsViewControllerSegue(_ segue : UIStoryboardSegue){
        let editLabelVC = segue.source as! EditLabelViewController
        let label = editLabelVC.label
        if let newLabelName = editLabelVC.labelNameField.text {
            label?.labelName = newLabelName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            labelManager.updateLable(label: label!)
            self.applyLabelFilter()
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Resources.Strings.Notifications.kLabelsUpdated)))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Resources.Strings.Label.kEditLabelSegue {
            let navigationController = segue.destination as! UINavigationController
            let editLabelViewController = navigationController.viewControllers[0] as! EditLabelViewController
            let label = self.filteredLabels?[(self.currentCellIndexPath?.row)!]
            editLabelViewController.label = label
        }
    }
    
    func editButtonAction(cell: LabelTableViewCell) {
        let indexPath = self.labelsTableView.indexPath(for: cell)
        self.currentCellIndexPath = indexPath!
    }
    
    func filterTasksForSelectedLabelAction(cell: LabelTableViewCell){
        let indexPath = self.labelsTableView.indexPath(for: cell)
        self.currentCellIndexPath = indexPath!
        
        if let tabBarController = self.tabBarController {
            let navigationController = tabBarController.customizableViewControllers?[0] as! UINavigationController
            let tasksViewController = navigationController.viewControllers[0] as! TasksViewController
            if let indexPath = indexPath {
                let label = self.filteredLabels?[indexPath.row]
                let selectedLabelName = label?.labelName
                tasksViewController.searchBar?.text = "#"  + selectedLabelName!
                tasksViewController.applyFilterPerSearchText()
                tabBarController.selectedIndex = 0
            }
        }
    }
    
    func deleteLabelCell(sender: LabelTableViewCell) {
        labelManager.deleteLabel(label: sender.label!)
        self.filteredLabels = self.filteredLabels?.filter() { $0 !== sender.label }
        self.labelsTableView.reloadData()
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Resources.Strings.Notifications.kLabelsUpdated)))
    }
    
    func fetchLabels() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        labelSearchBar.text = ""
        labelManager.allLabels(fetch: true, success: { (receivedLabels) in
            DispatchQueue.main.async {
                hud.hide(animated: true)
                self.applyLabelFilter()
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
        let cell = labelsTableView.dequeueReusableCell(withIdentifier: Resources.Strings.Label.kLabelTableViewCell, for: indexPath) as! LabelTableViewCell
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
        let labels = labelManager.getLabels()
        if searchText.characters.count == 0 {
            filteredLabels = labels
            labelsTableView.reloadData()
            return;
        }
        
        filteredLabels = [Labels]()
        for label in labels
        {
            if (label.labelName?.lowercased().contains(searchText.lowercased()))!
            {
                self.filteredLabels?.append(label)
            }
        }
        labelsTableView.reloadData()
    }
}
