//
//  LocationSearchTable.swift
//  GoTeamApp
//
//  Created by Wieniek Sliwinski on 4/28/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController, UISearchResultsUpdating {
  
  var matchingItems = [MKMapItem]()
  var mapView: MKMapView?
  var mapSearchDelegate: MapSearch?
  
  func updateSearchResults(for searchController: UISearchController) {
    
    guard
    let mapView = mapView,
    let searchBarText = searchController.searchBar.text else {
      return
    }
    let request = MKLocalSearchRequest()
    request.naturalLanguageQuery = searchBarText
    request.region = mapView.region
    let search = MKLocalSearch(request: request)
    search.start(completionHandler: {
      response, _ in
      guard let response = response else {
        return
      }
      self.matchingItems = response.mapItems
      self.tableView.reloadData()
    })
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return matchingItems.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let selectedItem = matchingItems[indexPath.row].placemark
    if let lines = selectedItem.addressDictionary?["FormattedAddressLines"] as? [String] {
        let address = lines.reduce("", { $0 == "" ? $1 : $0 + " " + $1 })
        cell.detailTextLabel?.text = address
    }
    cell.textLabel?.text = selectedItem.name

    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedItem = matchingItems[indexPath.row].placemark
    mapSearchDelegate?.createNewLocation(location: Location(placemark: selectedItem))
    dismiss(animated: true, completion: nil)
  }
}
