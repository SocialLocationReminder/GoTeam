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

    // state change related
    func reloadTable(sender : AnnotationControllerProtocol, annotationType: AnnotationType);
    func buttonTapped(sender : AnnotationControllerProtocol, annotationType: AnnotationType);

    
    // updates to text view
    func appendToTextView(sender : AnnotationControllerProtocol, string : String)
    func attributeTextView(sender : AnnotationControllerProtocol, pattern : String, options: NSString.CompareOptions, fgColor : UIColor, bgColor : UIColor)
    func removeFromTextView(sender: AnnotationControllerProtocol, character : String)
    
    // presentation segue related
    func present(sender: AnnotationControllerProtocol, controller : UIViewController)
    func perform(sender : AnnotationControllerProtocol, segue : String)
    
}

@objc protocol AnnotationControllerProtocol {

    weak var delegate : AnnotationControllerDelegate? {get set}
    
    // init
    func setup(button : UIImageView, textView : UITextView, annotationType : AnnotationType, task : Task);
    
    // state
    func setButtonStateAndAnnotation()
    func clearAnnotationInTask()
    @objc optional func userTriggedAnnotation()
    
    // table view data source 
    func numberOfSections() -> Int
    func numberOfRows(section: Int) -> Int
    func populate(cell : AddTaskCell, indexPath : IndexPath)
    
    // table view delegate
    func didSelect(_ indexPath : IndexPath)
    
    // segue and presentation related
    @objc optional func unwind(segue : UIStoryboardSegue)
    

}
