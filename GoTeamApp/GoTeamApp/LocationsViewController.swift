//
//  LocationsViewController.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 4/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD

enum AlertType {
  case addLocation
  case editLocation
}

protocol MapSearch {
  func createNewLocation(location: Location)
}

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate,MKMapViewDelegate, UIPopoverPresentationControllerDelegate ,MapSearch {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var barButton: UIBarButtonItem!
  @IBOutlet weak var addButton: UIButton!
  
  let selectedLocationsManager = SelectedLocationsManager.sharedInstance
  var selectedLocationIndex: Int?
  
  let locationManager = CLLocationManager()
  var resultSearchController: UISearchController?
  var showAlertInfo = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    tableView.delegate = self
    tableView.dataSource = self
    
    // Location Manager Setup
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
    
    // Setup search results table
    let locationSearchTable = storyboard?.instantiateViewController(withIdentifier: "LocationSearchTable") as? LocationSearchTable
    resultSearchController = UISearchController(searchResultsController: locationSearchTable)
    resultSearchController?.searchResultsUpdater = locationSearchTable
    
    // Add search bar to the top of map view
    if let searchBar = resultSearchController?.searchBar {
      searchBar.sizeToFit()
      searchBar.placeholder = "Search for a place or address"
      let searchBarView = UIView(frame: CGRect(x:0, y:8, width:searchBar.frame.size.width, height:44))
      searchBarView.addSubview(searchBar)
      mapView.addSubview(searchBarView)
    }
    resultSearchController?.hidesNavigationBarDuringPresentation = false
    resultSearchController?.dimsBackgroundDuringPresentation = true
    definesPresentationContext = true
    setupAddButton()
    locationSearchTable?.mapView = mapView
    locationSearchTable?.mapSearchDelegate = self
    
    // fetch locations
    fetchLocations()
  }
  
  func fetchLocations() {
    let hud = MBProgressHUD.showAdded(to: self.tableView, animated: true)
    selectedLocationsManager.allLocations(fetch: true, success: { (locations) in
      hud.hide(animated: true)
      // refresh the locations list and show location on the Map
      self.tableView.reloadData()
      self.mapView.addAnnotations(self.selectedLocationsManager.locations)
      self.mapView.showAnnotations(self.selectedLocationsManager.locations, animated: true)
    }) { (error) in
      hud.hide(animated: true)
      print(error)
      // @todo: show error alert
    }
  }
  
  func setupAddButton() {
    addButton.layer.cornerRadius = 48.0 / 2.0
    addButton.clipsToBounds = true
  }
  
  @IBAction func addLocationOnMap(_ sender: UILongPressGestureRecognizer) {
    if sender.state == .began {
      let coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
      let location = Location(latitude: coordinate.latitude, longitude: coordinate.longitude)
      location.title = "New location"
      mapView.addAnnotation(location)
      showAlert(type: .addLocation, location: location)
    }
  }
  
  func flipViews(fromView from: UIView, toView to: UIView, completion: ((Bool) -> Void)?) {
    let transitionParams :  UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
    UIView.transition(from: from, to: to, duration: 0.5, options: transitionParams, completion: completion)
    if barButton.title == "List" {
      barButton.title = "Map"
      addButton.isHidden = false
    } else {
      barButton.title = "List"
      addButton.isHidden = true
    }
  }
  
  @IBAction func addButtonTapped(_ sender: UIButton) {
    
    let alert = UIAlertController(title: nil, message: "Add New Location\nSearch for a place or address to find a location.\nOr tap and hold on the map to drop a location pin.", preferredStyle: UIAlertControllerStyle.actionSheet)
    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
    
    // show Alert Info only once when showAlertInfo == true
    var completion: ((Bool) -> Void)? = nil
    if showAlertInfo {
      completion = { (true) in self.present(alert, animated: true, completion: nil) }
      showAlertInfo = false
    }
    flipViews(fromView: self.tableView, toView: self.mapView, completion: completion)
  }
  
  @IBAction func listBarButtonTapped(_ sender: UIBarButtonItem) {
    if sender.title == "List" {
      flipViews(fromView: self.mapView, toView: self.tableView, completion: nil)
      for annotation in mapView.selectedAnnotations {
        mapView.deselectAnnotation(annotation, animated: false)
      }
      tableView.reloadData()
    } else {
      flipViews(fromView: self.tableView, toView: self.mapView, completion:
        { (success) in
          self.mapView.showAnnotations(self.selectedLocationsManager.locations, animated: true)})
    }
  }

  // MARK: - Location Manager Delegate Methods
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      self.locationManager.requestLocation()
    }
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      let span = MKCoordinateSpanMake(0.05, 0.05)
      let region = MKCoordinateRegionMake(location.coordinate, span)
      mapView.setRegion(region, animated: true)
    }
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("error:: (error)")
  }
  
  // MARK: - Map Search Delegate Method
  
  func createNewLocation(location: Location) {
    
    resultSearchController?.isActive = false
    mapView.addAnnotation(location)
    let span = MKCoordinateSpanMake(0.05, 0.05)
    let region = MKCoordinateRegionMake(location.coordinate, span)
    mapView.setRegion(region, animated: true)
    mapView.selectAnnotation(location, animated: true)
    
    showAlert(type: .addLocation, location: location)
  }
  
  func showAlert(type: AlertType, location: Location) {
    
    let alertController = MapAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    
    //Check if location with the same coordinates already exists
    var newType = type
    if newType == .addLocation {
      let newLocationID = String(describing: location.coordinate)
      let sameLocations = selectedLocationsManager.locations.filter() { $0.locationID == newLocationID }
      if sameLocations.count == 0 {
        newType = .addLocation
      } else {
        newType = .editLocation
      }
    }
    
    alertController.location = location
    let alertAction: UIAlertAction
    
    switch newType {
    case .addLocation :
      alertAction = UIAlertAction(title: "Add Location", style: .default, handler: {(alert: UIAlertAction!) in
        self.selectedLocationsManager.add(location: location)
        self.tableView.reloadData()
        self.selectedLocationIndex = self.selectedLocationsManager.locations.count - 1
        self.mapView.deselectAnnotation(location, animated: true)
        self.tableView.reloadData()
        self.flipViews(fromView: self.mapView, toView: self.tableView, completion: nil)
      })
    case .editLocation :
      alertAction = UIAlertAction(title: "Update Location", style: .default, handler: {(alert: UIAlertAction!) in
        
        print("TITLE = \(String(describing: alertController.location?.title))")
        print("SUBTITLE = \(String(describing: alertController.location?.subtitle))")
        
        // update location with new values
        if let index = self.selectedLocationIndex {
          let location = self.selectedLocationsManager.locations[index]
          location.title = alertController.location?.title
          location.subtitle = alertController.location?.subtitle
          self.selectedLocationsManager.locations[index] = location
          self.selectedLocationsManager.update(location: location)
        }
        
        self.tableView.reloadData()
        self.mapView.deselectAnnotation(location, animated: true)
        self.flipViews(fromView: self.mapView, toView: self.tableView, completion: nil)
      })
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in
      print("cancel")
      self.mapView.removeAnnotation(location)
      self.flipViews(fromView: self.mapView, toView: self.tableView, completion: nil)
    })
    
    alertController.addAction(alertAction)
    alertController.addAction(cancelAction)
    
    DispatchQueue.main.async {
      self.present(alertController, animated: true, completion:{})
    }
  }
  
  // MARK: - Map Pin Delegate Method
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil // standard blue dot for user location
    }
    
    let reuseId = "pin"
    var pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
    pinView.pinTintColor = UIColor.red
    pinView.canShowCallout = true
    let smallSquare = CGSize(width: 30, height: 30)
    let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
    button.setBackgroundImage(UIImage(named: "pin"), for: .normal)
    pinView.leftCalloutAccessoryView = button
    pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    return pinView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if control == view.rightCalloutAccessoryView {
      mapView.deselectAnnotation(view.annotation, animated: true)
      
      //performSegue(withIdentifier: "EditLocation", sender: view)
      
      if let location = view.annotation as? Location {
        print("SELECTED PIN TITLE= \(location.title ?? "")")
        print("SELECTED PIN ID= \(location.locationID!)")
        
        showAlert(type: .editLocation, location: location)
      }
    }
  }
  
  // MARK: - Table View Delegate Method
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedLocationsManager.locations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
    cell.location = selectedLocationsManager.locations[indexPath.row] //Array(locations.values)[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let location = selectedLocationsManager.locations[indexPath.row] //Array(locations.values)[indexPath.row]
    selectedLocationIndex = indexPath.row
    
    let span = MKCoordinateSpanMake(0.05, 0.05)
    let region = MKCoordinateRegionMake(location.coordinate, span)
    mapView.setRegion(region, animated: true)
    
    print("SELECTED LOCATION NAME = \(location.title!)")
    print("COORDINATE = \(String(describing: location.coordinate))")
    
    flipViews(fromView: self.tableView, toView: self.mapView) { (success) in
      if success {
        self.mapView.addAnnotation(location)
        self.mapView.selectAnnotation(location, animated: true)
      }
    }
  }
}
