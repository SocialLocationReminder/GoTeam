//
//  Contact.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/6/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import APAddressBook


class Contact {
    
    static let kContactClass = "ContactClassV1"
    
    static let kContactID = "kContactID"
    static let kFullName  = "kFullName"
    static let kFirstName = "kFirstName"
    static let kLastName  = "kLastName"
    static let kPhone     = "kPhone"
    static let kEmail     = "kEmail"
    
    var contactID : String?
    var fullName : String?
    var firstName : String?
    var lastName : String?
    var phone : String?
    var email : String?
    
    static func contact(apContact: APContact) -> Contact {
        let contact = Contact()
        contact.fullName = apContact.fullName()
        contact.firstName = apContact.name?.firstName
        contact.lastName = apContact.name?.lastName
        contact.phone = apContact.phones?.first?.number
        contact.email = apContact.emails?.first?.address
        return contact
    }
}
