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

class SpeechToTextAnnotationController : NSObject, AnnotationControllerProtocol, SFSpeechRecognizerDelegate {
    
    // public
    var annotationType : AnnotationType!
    
    // delegate
    weak internal var delegate: AnnotationControllerDelegate?
    
    // private,internal
    var textView : UITextView!
    private var task : Task!
    private var button : UIImageView!
    private var infoLabel : UILabel?
    private static let kNumberOfSections = 2
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()



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
        
        setupSpeechRecognizer()
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
        if button.isHighlighted == false {
            requestAuthorization()
            self.infoLabel?.text = Resources.Strings.AddTasks.kSpeechPrompt
            button.isHighlighted = true
            startRecording()
        } else {
            self.infoLabel?.text = ""
            button.isHighlighted = false
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
        // delegate?.buttonTapped(sender: self, annotationType: annotationType)
    }
    
    
    func requestAuthorization()  {
        var isButtonEnabled = false
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.button.isUserInteractionEnabled = isButtonEnabled
            }
        }
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
    
    // MARK: speech recognization stuff
    func setupSpeechRecognizer() {
        speechRecognizer.delegate = self
    }
    
    func startRecording() {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }  //4
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString  //9
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.button.isUserInteractionEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        // textView.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            button.isUserInteractionEnabled = true
        } else {
            button.isUserInteractionEnabled = false
        }
    }

}

