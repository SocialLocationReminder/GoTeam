//
//  TaskSpecialCharacters.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/30/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


enum TaskSpecialCharacter : Character {
    case priority = "!"
    case fromDate = "~"
    case dueDate = "^"
    case label = "#"
    case recurrence = "*"
    case location = "@"
    case contact = "+"
    func stringValue() -> String {
        return String(rawValue)
    }
}
