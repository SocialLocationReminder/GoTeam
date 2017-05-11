//
//  ContactManager.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/7/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


class ContactManager {
    
    let dataStoreService : ContactDataStoreServiceProtocol = ContactDataStoreService()
    
    let queue = DispatchQueue(label: Resources.Strings.ContactManager.kContactManagerQueue)
    
    static let sharedInstance = ContactManager()

    func add(contact : Contact, success:@escaping () -> (), error: @escaping ((Error) -> ())) {
        queue.async {
            self.dataStoreService.add(contact: contact, success: success, error: error)
        }
    }
    
    func delete(contact : Contact, success:@escaping () -> (), error: @escaping ((Error) -> ())) {
        queue.async {
            self.dataStoreService.delete(contact: contact, success: success, error: error)
        }
    }
    
    func fetchAllContacts(success:@escaping ([Contact]) -> (), error: @escaping ((Error) -> ())) {
        queue.async {
            self.dataStoreService.fetchAllContacts(success: success, error: error)
        }
    }
}
