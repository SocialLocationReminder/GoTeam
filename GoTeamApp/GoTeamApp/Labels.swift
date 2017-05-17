//
//  Labels.swift
//  GoTeamApp
//
//  Created by Patchirajan, Karpaga Ganesh on 4/30/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class Labels: ListItem {
    
    static let kLabelsClass = "LabelsClassV2"
    static let kTUserName = "UserName"
    static let kLabelID   = "labelID"
    static let kLabelName = "labelName"

    
    var labelID : Date?
    var labelName : String?
    
    init() {
        labelID = Date()
    }
}
