//
//  AnnotationControllerProtocol.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/7/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit

@objc enum AnnotationType : Int {
    case none
    case fromDate
    case dueDate
    case priority
    case label
    case recurrence
    case location
    case contact
}


@objc protocol AnnotationControllerDelegate {

    func buttonTapped(sender : AnnotationControllerProtocol, annotationType: AnnotationType);
    func perform(segue : String)
    func appendToTextView(string : String)
    func attributeTextView(pattern : String, options: NSString.CompareOptions, fgColor : UIColor, bgColor : UIColor)
}

@objc protocol AnnotationControllerProtocol {

    weak var delegate : AnnotationControllerDelegate? {get set}
    func setup(button : UIButton, textView : UITextView, annotationType : AnnotationType, task : Task);
    
    // table view data source related
    func numberOfSections() -> Int
    func numberOfRows(section: Int) -> Int
    func populate(cell : AddTaskCell, indexPath : IndexPath)
    
    // table view delegate
    func didSelect(_ indexPath : IndexPath)
}
