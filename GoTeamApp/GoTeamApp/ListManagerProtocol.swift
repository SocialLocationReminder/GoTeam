//
//  ListManagerProtocol.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation

protocol ListManagerProtocol {
    
    func add(item : ListItem);
    func delete(item : ListItem);
    func allItems() -> [ListItem]?
}
