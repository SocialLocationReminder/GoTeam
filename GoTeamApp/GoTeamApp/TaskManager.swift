//
//  TaskManager.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/28/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


class TaskManager {
    
    var tasks = [Task]()
    let dataStoreService : DataStoreServiceProtocol = DataStoreService()
    
    let queue = DispatchQueue(label: "TaskManagerQueue")
    
    func add(task : Task) {
        queue.async {
            self.tasks.append(task)
            self.dataStoreService.add(task: task)
        }
    }
    
    func delete(task : Task) {
        queue.async {
            self.tasks = self.tasks.filter() { $0 !== task }
        }
    }

    func allTasks(fetch: Bool, success:@escaping (([Task]) -> ()), error: @escaping (Error) -> ()) {
        queue.async {
            if fetch == false {
                success(self.tasks)
            } else {
                self.dataStoreService.allTasks(success: success, error: error)
            }
        }
    }
}
