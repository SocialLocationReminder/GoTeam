//
//  LabelDataStore.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/5/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation

import Foundation
import Parse

class LabelDataStoreService : LabelDataStoreServiceProtocol {
    
    
    // user related
    let kTUserName = "UserName"
    
    let queue = DispatchQueue(label: Resources.Strings.LabelDataStoreService.kLabelDataStoreServiceQueue)
    
    // label related
    let kLabelsClass = "LabelsClassV2"
    var userName = "akshay"
    

    func add(label : Labels) {
        
        let parseTask = PFObject(className:kLabelsClass)
        parseTask[Labels.kTUserName] = userName
        parseTask[Labels.kLabelName] = label.labelName
        parseTask[Labels.kLabelID] = label.labelID
        parseTask.saveInBackground { (success, error) in
            if success {
                print("saved successfully")
            } else {
                print(error)
            }
        }
    }
    
    func update(label : Labels) {
        let query = PFQuery(className:kLabelsClass)
        query.whereKey(Labels.kTUserName, equalTo: userName)
        query.whereKey(Labels.kLabelID, equalTo: label.labelID!)
        query.includeKey(userName)
        query.findObjectsInBackground(block: { (labels, returnedError) in
            if let labels = labels {
                labels.first?[Labels.kLabelName] = label.labelName
                labels.first?.saveInBackground()
            }
        })
    }
    
    func delete(label : Labels) {
        let query = PFQuery(className:kLabelsClass)
        query.whereKey(Labels.kTUserName, equalTo: userName)
        query.whereKey(Labels.kLabelID, equalTo: label.labelID!)
        query.includeKey(Labels.kLabelID)
        query.findObjectsInBackground(block: { (labels, error) in
            if let labels = labels {
                labels.first?.deleteEventually()
            }
        })
    }
    
    
    func allLabels(success:@escaping ([Labels]) -> (), error: @escaping ((Error) -> ())) {
        let query = PFQuery(className:Labels.kLabelsClass)
        query.whereKey(Labels.kTUserName, equalTo: userName)
        query.includeKey(userName)
        query.findObjectsInBackground(block: { (labels, returnedError) in
            self.queue.async {
                if let labels = labels {
                    success(self.convertToLabels(pfLabels: labels))
                } else {
                    if let returnedError = returnedError {
                        error(returnedError)
                    } else {
                        error(NSError(domain: "failed to get labels, unknown error", code: 0, userInfo: nil))
                    }
                }
            }
        })
    }
    
 
    
    func convertToLabels(pfLabels : [PFObject]) -> [Labels] {
        var labels = [Labels]()
        for pfLabel in pfLabels {
            let label = Labels()
            label.labelID = pfLabel[Labels.kLabelID] as? Date
            label.labelName = pfLabel[Labels.kLabelName] as? String
            labels.append(label)
        }
        return labels
    }
    
    static func parseObject(label : Labels) -> PFObject? {
        let query = PFQuery(className:Labels.kLabelsClass)
        query.whereKey(Labels.kTUserName, equalTo: "akshay")
        query.includeKey(Labels.kTUserName)
        query.whereKey(Labels.kLabelID, equalTo: label.labelID!)
        
        var objects : [PFObject]?
        do {
            objects = try query.findObjects()
        } catch _ {
            return nil
        }
        return objects?.first
    }
    
    static func label(parseObject: PFObject) -> Labels {
        let label = Labels()
        
        label.labelName = parseObject[Labels.kLabelName] as? String
        label.labelID =  parseObject[Labels.kLabelID] as? Date
        return label
    }
}
