//
//  GroupDataStoreService.swift
//  GoTeamApp
//
//  Created by Patchirajan, Karpaga Ganesh on 5/14/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import Parse
import Foundation

class GroupDataStoreService : GroupDataStoreServiceProtocol {

    // user related
    var userName = "akshay"
    
    // application layer
    let contactManager = ContactManager.sharedInstance
    
    func add(group : Group, success:@escaping () -> (), error: @escaping ((Error) -> ())) {
        let pfGroup = newParseObject(group: group)
        pfGroup[User.kUserName] = userName
        pfGroup.saveInBackground { (successStatus, errorStatus) in
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
    
    func allGroups(success:@escaping ([Group]) -> (), error: @escaping ((Error) -> ())) {
        
        let query = PFQuery(className:Group.kGroupClass)
        query.whereKey(User.kUserName, equalTo: userName)
        query.includeKey(userName)
        
        query.findObjectsInBackground(block: { (pfGroups, returnedError) in
            if let pfGroups = pfGroups {
                let groups = self.convertToGroups(pfGroups : pfGroups)
//                self.deleteGroups(groups: groups)
                success(groups)
            } else {
                if let returnedError = returnedError {
                    error(returnedError)
                } else {
                    error(NSError(domain: "failed to get groups, unknown error", code: 0, userInfo: nil))
                }
            }
        })
    }
    
    func deleteGroups(groups : [Group]) {
        for group in groups {
            let query = PFQuery(className:Group.kGroupClass)
            query.whereKey(User.kUserName, equalTo: userName)
            query.whereKey(Group.kgroupID, equalTo: group.groupID!)
            query.includeKey(Group.kgroupID)
            query.findObjectsInBackground(block: { (group, error) in
                if let group = group {
                    group.first?.deleteEventually()
                }
            })

        }
    }
    
    func convertToGroups(pfGroups : [PFObject]) -> [Group] {
        var groups = [Group]()
        for pfGroup in pfGroups {
            let group = Group()
            do {
                group.groupID = pfGroup[Group.kgroupID] as? Date
                group.groupName = pfGroup[Group.kgroupName] as? String
                group.contacts = [Contact]()
                
                let commaSeperatedContactIDs = pfGroup[Group.kcontactIDs] as? String
                let contactIDs = commaSeperatedContactIDs?.components(separatedBy: ",")
                var parseObjectsArray = [PFObject]()
                for contactID in contactIDs! {
                    if contactID.characters.count > 0 {
                        if let parseObject = ContactDataStoreService.pfObjectFor(contactID: contactID) {
                            parseObjectsArray.append(parseObject)
                        }
                    }
                }
                if parseObjectsArray.count > 0 {
                    group.contacts = ContactDataStoreService.convertToContacts(pfContacts: parseObjectsArray)
                }
            } catch _  {
                print("exception while attempting to convert pfobjects to tasks")
            }
            groups.append(group)
        }
        return groups
    }
    
    func newParseObject(group: Group) -> PFObject {
        let pfObject = PFObject(className:Group.kGroupClass)
        if let groupID = group.groupID {
            pfObject[Group.kgroupID] = groupID
        }
        if let groupName = group.groupName {
            pfObject[Group.kgroupName] = groupName
        }
        var commaSeperatedContactIDs : String = ""
        
        if let contacts = group.contacts {
            for contact in contacts {
                let contactID = contact.contactID as String!
                commaSeperatedContactIDs = commaSeperatedContactIDs + contactID! + ","
            }
            pfObject[Group.kcontactIDs] = commaSeperatedContactIDs
        }
        return pfObject
    }
}
