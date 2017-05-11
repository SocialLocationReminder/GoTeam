//
//  SpeechToTextAnnotationController.swift
//  GoTeamApp
//
//  Created by Akshay Bhandary on 5/11/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import Foundation
import UIKit
import Speech

class SpeechToTextAnnotationController : AnnotationControllerProtocol {
    weak internal var delegate: AnnotationControllerDelegate?
    
    var textView : UITextView!
    var task : Task!
    var button : UIImageView!
    
    var infoLabel : UILabel?
    
    static let kNumberOfSections = 2
    var annotationType : AnnotationType!

    func set(infoLabel : UILabel!) {
        self.infoLabel = infoLabel
    }
    
    // MARK: - init
    func setup(button : UIImageView, textView : UITextView, annotationType : AnnotationType, task : Task) {
        
        self.textView = textView
        self.annotationType = annotationType
        self.task = task
        self.button = button
        
        setupGestureRecognizer()
    }
    
    func clearAnnotationInTask() {
        task.taskDateSubrange = nil
        task.taskDate = nil
    }
    
    func setupGestureRecognizer() {
        button.isHighlighted = false
        let buttonTapGR = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        button.addGestureRecognizer(buttonTapGR)
    }
    
    // MARK: - gesture recognizer
    @objc func buttonTapped(sender : UITapGestureRecognizer) {
        self.infoLabel?.isHidden = false
        self.infoLabel?.text = Resources.Strings.AddTasks.kSpeechPrompt
        button.isHighlighted = true
        // delegate?.buttonTapped(sender: self, annotationType: annotationType)
    }
    
    // MARK: - button state
    func setButtonStateAndAnnotation() {
        
    }
    
    // MARK: - Table View data source related
    func numberOfSections() -> Int {
        return 0
    }
    
    func numberOfRows(section: Int) -> Int {
        return 0
    }
    
    func populate(cell : AddTaskCell, indexPath : IndexPath)  {
        assert(false)        
    }
    
    // MARK: - table view delegate related
    func didSelect(_ indexPath : IndexPath) {
        assert(false)
    }

}
