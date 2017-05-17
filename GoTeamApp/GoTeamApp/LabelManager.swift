import Foundation

class LabelManager{

    var labels = [Labels]()
    let dataStoreService : LabelDataStoreServiceProtocol = LabelDataStoreService()
    
    var selectedLabel: Labels? = nil
    
    static let sharedInstance = LabelManager()
    
    let queue = DispatchQueue(label: Resources.Strings.LabelManager.kLabelManagerQueue)
    
    func add(label: Labels){
        queue.async {
            self.labels.append(label)
            self.dataStoreService.add(label: label)
        }
    }
    
    func deleteLabel(label : Labels) {
        queue.async {
            self.labels = self.labels.filter() { $0 !== label }
            self.dataStoreService.delete(label: label)
        }
    }
    
    func updateLable(label: Labels){
        queue.async {
            self.dataStoreService.update(label: label)
        }
    }
    
    func allLabels(fetch: Bool, success:@escaping (([Labels]) -> ()), error: @escaping (Error) -> ()) {
        queue.async {
            if fetch == false {
                success(self.labels)
            } else {
                self.dataStoreService.allLabels(success: { (receivedLabels) in
                    self.labels = receivedLabels
                    success(self.labels)
                }, error: error)
            }
        }
    }
    
    func getLabels() -> [Labels] {
        var result : [Labels]!
        queue.sync {
            result = labels
        }
        return result;
    }
}
