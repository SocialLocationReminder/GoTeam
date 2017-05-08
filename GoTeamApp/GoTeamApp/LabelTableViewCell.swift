import UIKit

protocol LabelTableViewCellDelegate {
    func editButtonAction(cell: LabelTableViewCell)
    func filterTasksForSelectedLabelAction(cell: LabelTableViewCell)
    func deleteLabelCell(sender : LabelTableViewCell)
}

class LabelTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var editLabelButton: UIButton!
    @IBOutlet weak var tasksFilterButton: UIButton!
    
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var topView: UIView!
    var delegate: LabelTableViewCellDelegate?
    
    var tableCellUtil : TableCellUtil!
    
    var label : Labels? {
        didSet {
            cellFGViewLeadingSpaceConstraint.constant = 0
            if let label = label {
                self.labelName.text = label.labelName
            }
        }
    }
    
    @IBOutlet weak var cellFGViewLeadingSpaceConstraint: NSLayoutConstraint!
    
    @IBAction func editButtonAction(_ sender: Any) {
        if let _ = delegate {
            delegate?.editButtonAction(cell: self)
        }
    }
    
    @IBAction func filterTasksForSelectedLabelAction(_ sender: Any) {
        if let _ = delegate {
            delegate?.filterTasksForSelectedLabelAction(cell: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellFGViewLeadingSpaceConstraint.constant = 0
        let tapGR = UIPanGestureRecognizer(target: self, action: #selector(topViewPanned))
        self.topView.addGestureRecognizer(tapGR)
        tableCellUtil = TableCellUtil(contentView: contentView, viewLeadingConstraint: cellFGViewLeadingSpaceConstraint)
    }
    
    func topViewPanned(sender : UIPanGestureRecognizer) {
        tableCellUtil.handleDeletePan(sender: sender, deleteActionComplete: {
            self.delegate?.deleteLabelCell(sender: self)
        }, deleteActionInComplete: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
