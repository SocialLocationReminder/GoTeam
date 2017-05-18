//
//  DateTimeUtil.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/12/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation

enum DateFormatType {
    case dateOnly
    case timeOnly
    case dateAndTime
}

struct FindDateTimeResult {
    var rangeFound : Range<String.Index>?
    var patternFound : String?
    var specialCharPresent  = false
    var dateFormat : String?
    var dateFormatType : DateFormatType?
}

class DateTimeUtil {

    static func findDateOrTimePattern(specialChar: String, text: String)
            -> FindDateTimeResult {

        var result = FindDateTimeResult()
                
        
        let dateRegEx = Resources.Strings.RegEx.kDateRegExPattern
        let fullTimeRegEx = Resources.Strings.RegEx.kFullTimeRegExPattern
        let shortTimeRegEx =  Resources.Strings.RegEx.kHourOnlyTimeRegExPattern
        
        var patterns = [
            dateRegEx + "\\s*at" + fullTimeRegEx,
            dateRegEx,
            "\\s*at" + fullTimeRegEx,
            "\\s*at" + shortTimeRegEx,
            ]
        var patternsWithSpecialChar = patterns.map { "\\" + specialChar + $0}
        patternsWithSpecialChar.append(contentsOf: patterns)
        patterns = patternsWithSpecialChar
        
        var dateFormats : [(String, DateFormatType)] = [
            ("ddMMMyyyy'at'hh:mma", .dateAndTime),
            ("ddMMMyyyy", .dateOnly),
            ("'at'hh:mma", .timeOnly),
            ("'at'hha", .timeOnly)
            ]
        dateFormats.append(contentsOf: dateFormats)
                
        
        // check if present with special character
        for ix in 0..<patterns.count {
            if let range = text.range(of: patterns[ix], options: .regularExpression, range: nil, locale: nil),
                !range.isEmpty{
                result.rangeFound = range
                result.patternFound = patterns[ix]
                result.specialCharPresent = patterns[ix].contains(specialChar)
                result.dateFormat = dateFormats[ix].0
                result.dateFormatType = dateFormats[ix].1
                return result;
            }
        }
        
        return result
    }
}
