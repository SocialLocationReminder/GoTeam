//
//  Regex.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 4/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation


class Regex {
    let internalExpression: NSRegularExpression!
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        self.internalExpression =  try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func test(input: String) -> Bool {
        let chars = Array(input.characters)
        let matches = self.internalExpression.matches(in: input, options: [], range:NSMakeRange(0, chars.count))
        return matches.count > 0
    }
    
//    func firstMatch(input : String) -> String? {
//        let chars = Array(input.characters)
//        let firstMatch = self.internalExpression.firstMatch(in: input, options: [], range: NSMakeRange(0, chars.count))
//        
//    }
}
