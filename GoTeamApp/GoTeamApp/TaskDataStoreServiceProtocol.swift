//
//  TaskDataStoreServiceProtocol.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/5/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation

protocol TaskDataStoreServiceProtocol {
    func add(task : Task);
    func delete(task : Task);
    func allTasks(success:@escaping ([Task]) -> (), error: @escaping ((Error) -> ()));
}
