//
//  DataStoreServiceProtocol.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/28/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


protocol DataStoreServiceProtocol {
    func add(task : Task);
    func add(label : Labels);
    func delete(task : Task);
    func delete(label : Labels);
    func allTasks(success:@escaping ([Task]) -> (), error: @escaping ((Error) -> ()));
    func allLabels(success:@escaping ([Labels]) -> (), error: @escaping ((Error) -> ()));
}
