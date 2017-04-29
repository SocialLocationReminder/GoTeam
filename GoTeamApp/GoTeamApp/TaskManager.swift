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
}
