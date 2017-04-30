//
//  EditLocationViewController.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 4/28/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import MapKit

class EditLocationViewController: UIViewController, UITextFieldDelegate {
  
  var location: Location?
  
  @IBOutlet weak var nameField: UITextField! {
    didSet {
      nameField.delegate = self
    }
  }
  @IBOutlet weak var infoField: UITextField! {
    didSet {
      infoField.delegate = self
    }
  }
  
  func updateUI() {
    nameField?.text = location?.title ?? ""
    infoField?.text = location?.subtitle ?? ""
  }
  
  var ntfObserver: NSObjectProtocol?
  var itfObserver: NSObjectProtocol?
  
  func listenToTextFields() {
    
    let center = NotificationCenter.default
    let queue = OperationQueue.main
    
    ntfObserver = center.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: nameField, queue: queue, using: { notification in
      if let location = self.location {
        location.title = self.nameField.text
      }
    })
    
    itfObserver = center.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: infoField, queue: queue, using: { notification in
      if let location = self.location {
        location.subtitle = self.infoField.text
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
    textField.resignFirstResponder()
    performSegue(withIdentifier: "unwindSegue", sender: self)
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
    nameField.becomeFirstResponder()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    listenToTextFields()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    stopListeningToTextFields()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
  }
  
}
