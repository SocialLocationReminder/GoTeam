//
//  MapAlertView.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 5/2/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class MapAlertView: UIView, UITextFieldDelegate {
  
  var location: Location?
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var nameTextField: UITextField! {
    didSet {
      nameTextField.delegate = self
    }
  }
  @IBOutlet weak var addressTextField: UITextField! {
    didSet {
      addressTextField.delegate = self
    }
  }
  
  var name: String? {
    get { return nameTextField?.text }
    set { nameTextField.text = newValue }
  }
  
  var address: String? {
    get { return addressTextField?.text }
    set { addressTextField.text = newValue }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initSubviews()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initSubviews()
  }
  
  func initSubviews() {
    let nib = UINib(nibName: "MapAlertView", bundle: nil)
    nib.instantiate(withOwner: self, options: nil)
    contentView.frame = bounds
    addSubview(contentView)
  }
  
  var ntfObserver: NSObjectProtocol?
  var itfObserver: NSObjectProtocol?
  
  func listenToTextFields() {
    
    let center = NotificationCenter.default
    let queue = OperationQueue.main
    
    ntfObserver = center.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: nameTextField, queue: queue, using: { notification in
      if let location = self.location {
        location.title = self.nameTextField.text
      }
    })
    
    itfObserver = center.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: addressTextField, queue: queue, using: { notification in
      if let location = self.location {
        location.subtitle = self.addressTextField.text
      }
    })
  }
  
  func stopListeningToTextFields() {
    if let observer = ntfObserver {
      NotificationCenter.default.removeObserver(observer)
    }
    if let observer = itfObserver {
      NotificationCenter.default.removeObserver(observer)
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //textField.resignFirstResponder()
    print("RETURN")
    return true
  }
}
