//
//  LocationsViewController.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 4/29/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import MapKit

protocol MapSearch {
  func createNewLocation(location: Location)
}

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate,MKMapViewDelegate, UIPopoverPresentationControllerDelegate ,MapSearch {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var barButton: UIBarButtonItem!
  
  var locations = [Location]()
  var selectedLocationIndex: Int?
  
  let locationManager = CLLocationManager()
  var resultSearchController: UISearchController?
  
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
    
    locationSearchTable?.mapView = mapView
    locationSearchTable?.mapSearchDelegate = self
  }
  
  // Flip between Map View and List View
  @IBAction func listBarButtonTapped(_ sender: UIBarButtonItem) {
    
    if sender.title == "List" {
      let transitionParams :  UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
      UIView.transition(from: self.mapView,
                        to: self.tableView,
                        duration: 0.5,
                        options: transitionParams,
                        completion: nil);
      for annotation in mapView.selectedAnnotations {
        mapView.deselectAnnotation(annotation, animated: false)
      }
      tableView.reloadData()
    } else {
      let transitionParams :  UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
      UIView.transition(from: self.tableView,
                        to: self.mapView,
                        duration: 0.5,
                        options: transitionParams,
                        completion: nil);
    }
    sender.title = sender.title == "List" ? "Map" : "List"
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "EditLocation" {
      
      let viewController = segue.destination as? EditLocationViewController
      let annotationView = sender as? MKAnnotationView
      let location = annotationView?.annotation as? Location
      viewController?.location = location
      if let popoverController = viewController?.popoverPresentationController {
        popoverController.delegate = self
        popoverController.sourceRect = annotationView!.frame
      }
    }
  }
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
  
  // unwind action for the unwindsegue
  @IBAction func updatedPinDescription(segue: UIStoryboardSegue) {
    if let updatedPin = (segue.source as? EditLocationViewController)?.location {
      mapView.selectAnnotation(updatedPin, animated: true)
      // update locations dictionary with new values
      if let index = selectedLocationIndex {
        let location = locations[index]
        location.title = updatedPin.title
        location.subtitle = updatedPin.subtitle
        locations[index] = location
      }
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
    
    //add to locations list
    locations.append(location)
    selectedLocationIndex = locations.count - 1
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
      performSegue(withIdentifier: "EditLocation", sender: view)
      
    }
  }
  
  // MARK: - Table View Delegate Method
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
    cell.location = locations[indexPath.row] //Array(locations.values)[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let location = locations[indexPath.row] //Array(locations.values)[indexPath.row]
    selectedLocationIndex = indexPath.row
    
    barButton.title = "List"
    let span = MKCoordinateSpanMake(0.05, 0.05)
    let region = MKCoordinateRegionMake(location.coordinate, span)
    mapView.setRegion(region, animated: true)
    
    let transitionParams :  UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
    UIView.transition(from: self.tableView,
                      to: self.mapView,
                      duration: 0.5,
                      options: transitionParams,
                      completion: { (success) in if success {
                        self.mapView.addAnnotation(location)
                        self.mapView.selectAnnotation(location, animated: true)
                        }
    })
  }
}
