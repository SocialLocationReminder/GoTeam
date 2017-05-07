//
//  ContactDataStoreService.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/7/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation

import Parse

class ContactDataStoreService : ContactDataStoreServiceProtocol {

    
    func add(contact : Contact, success:@escaping () -> (), error: @escaping ((Error) -> ())) {
        
        let parseTask = ContactDataStoreService.newParseObject(contact: contact)
        parseTask.saveInBackground { (successStatus, errorStatus) in
            if successStatus {
                success()
            } else {
                if let errorStatus = errorStatus {
                    error(errorStatus)
                } else {
                    error(NSError(domain: Resources.Strings.DataStoreService.kUnknownError,
                                  code: DataStoreServiceErrorCodes.unknown.rawValue, userInfo: nil))
                }
            }
        }
    }
    
    func delete(contact : Contact, success:@escaping () -> (), error: @escaping ((Error) -> ())) {
        
    }

    func fetchAllContacts(success:@escaping ([Contact]) -> (), error: @escaping ((Error) -> ())) {
        
    }

    static func contact(pfObject: PFObject) -> Contact {
        let contact = Contact()
        contact.contactID = pfObject[Contact.kContactID] as? String
        contact.fullName  = pfObject[Contact.kFullName] as? String
        contact.firstName = pfObject[Contact.kFirstName] as? String
        contact.lastName  = pfObject[Contact.kLastName] as? String
        contact.phone     = pfObject[Contact.kPhone] as? String
        contact.email     = pfObject[Contact.kEmail] as? String
        return contact
    }
    
    static func pfObjectFor(contact: Contact) -> PFObject? {
        
        let query = PFQuery(className:Contact.kContactClass)
        query.whereKey(User.kUserName, equalTo: "akshay")
        query.whereKey(Location.kLocationID, equalTo: contact.contactID!)
        
        var objects : [PFObject]?
        do {
            objects = try query.findObjects()
        } catch _ {
            return nil
        }
        return objects?.first
    }
    
    
    internal static func newParseObject(contact: Contact) -> PFObject {
        let pfObject = PFObject()
        
        if let contactID = contact.contactID {
            pfObject[Contact.kContactID] = contactID
        }
        if let fullName = contact.fullName {
            pfObject[Contact.kFullName] = fullName
        }
        if let firstName = contact.firstName {
            pfObject[Contact.kFirstName] = firstName
        }
        if let lastName = contact.lastName {
            pfObject[Contact.kLastName] = lastName
        }
        if let phone = contact.phone {
            pfObject[Contact.kPhone] = phone
        }
        if let email = contact.email {
            pfObject[Contact.kEmail] = email
        }
        return pfObject
    }
    

}
