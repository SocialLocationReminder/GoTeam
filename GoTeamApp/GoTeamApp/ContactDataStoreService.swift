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
        let parseContact = ContactDataStoreService.newParseObject(contact: contact)
        parseContact[User.kUserName] = User.kCurrentUser
        parseContact.saveInBackground { (successStatus, errorStatus) in
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
        let query = PFQuery(className:Contact.kContactClass)
        query.whereKey(User.kUserName, equalTo: User.kCurrentUser)
        query.includeKey(User.kUserName)
        query.findObjectsInBackground(block: { (pfContacts, returnedError) in
            if let pfContacts = pfContacts {
                let contacts = ContactDataStoreService.convertToContacts(pfContacts : pfContacts)
                success(contacts)
            } else {
                if let returnedError = returnedError {
                    error(returnedError)
                } else {
                    error(NSError(domain: "failed to get groups, unknown error", code: 0, userInfo: nil))
                }
            }
        })
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
    
    static func pfObjectFor(contactID: String) -> PFObject? {
        
    
        let query = PFQuery(className:Contact.kContactClass)
        query.whereKey(User.kUserName, equalTo: User.kCurrentUser)
        query.whereKey(Contact.kContactID, equalTo: contactID)
        query.includeKey(User.kUserName)
        query.includeKey(Contact.kContactID)
        
        var objects : [PFObject]?
        do {
            objects = try query.findObjects()
        } catch _ {
            return nil
        }
        return objects?.first
    }
    
    static func convertToContacts(pfContacts : [PFObject]) -> [Contact] {
        var contacts = [Contact]()
        for pfContact in pfContacts {
            let contact = Contact()
            contact.contactID = pfContact[Contact.kContactID] as? String
            contact.email  = pfContact[Contact.kEmail] as? String
            contact.firstName = pfContact[Contact.kFirstName] as? String
            contact.lastName = pfContact[Contact.kLastName] as? String
            contact.fullName = pfContact[Contact.kFullName] as? String
            contact.phone = pfContact[Contact.kPhone] as? String
            contacts.append(contact)
        }
        return contacts
    }
    
    internal static func newParseObject(contact: Contact) -> PFObject {
        let pfObject = PFObject(className:Contact.kContactClass)
        
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
