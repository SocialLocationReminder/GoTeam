//
//  MapAlertController.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 5/5/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class MapAlertController: UIAlertController {

  var location: Location?
  var alertView: MapAlertView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let margin:CGFloat = 10.0
    let rect = CGRect(x: margin, y: margin, width: view.bounds.size.width - margin * 4.0, height: 120)
    alertView = MapAlertView(frame: rect)
    view.addSubview(alertView!)
    alertView?.location = location
    updateUI()
    //alertView?.nameTextField.becomeFirstResponder()
  }
  
  func updateUI() {
    alertView?.name = location?.title ?? ""
    alertView?.address = location?.subtitle ?? ""
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    alertView?.listenToTextFields()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    alertView?.stopListeningToTextFields()
  }
}
