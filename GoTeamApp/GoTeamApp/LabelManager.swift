import Foundation

class LabelManager{

    var labels = [Labels]()
    let dataStoreService : DataStoreServiceProtocol = DataStoreService()
    
    let queue = DispatchQueue(label: "LabelManagerQueue")
    
    func add(label: Labels){
        queue.async {
            self.labels.append(label)
            self.dataStoreService.add(label: label)
        }
    }
    
    func delete(label : Labels) {
        queue.async {
            self.labels = self.labels.filter() { $0 !== label }
            self.dataStoreService.delete(label: label)
        }
    }
    
    func allLabels(fetch: Bool, success:@escaping (([Labels]) -> ()), error: @escaping (Error) -> ()) {
        queue.async {
            if fetch == false {
                success(self.labels)
            } else {
                self.dataStoreService.allLabels(success: success, error: error)
            }
        }
    }
}
