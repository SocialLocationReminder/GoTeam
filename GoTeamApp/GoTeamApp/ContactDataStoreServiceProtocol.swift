//
//  ContactDataStoreServiceProtocol.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/7/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation

protocol ContactDataStoreServiceProtocol {
    func add(contact : Contact, success:@escaping () -> (), error: @escaping ((Error) -> ()));
    func delete(contact : Contact, success:@escaping () -> (), error: @escaping ((Error) -> ()));
    func fetchAllContacts(success:@escaping ([Contact]) -> (), error: @escaping ((Error) -> ()));
}
