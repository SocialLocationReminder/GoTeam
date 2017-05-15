//
//  GroupDataStoreServiceProtocol.swift
//  GoTeamApp
//
//  Created by Patchirajan, Karpaga Ganesh on 5/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

protocol GroupDataStoreServiceProtocol {
    func add(group : Group, success:@escaping () -> (), error: @escaping ((Error) -> ()));
    func allGroups(success:@escaping ([Group]) -> (), error: @escaping ((Error) -> ()));
}
