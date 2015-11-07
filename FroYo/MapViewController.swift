//
//  MapViewController.swift
//  FroYo
//
//  Created by Eric Kim on 11/7/15.
//  Copyright © 2015 EKEY. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import MBProgressHUD


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

  @IBOutlet weak var mapView: MKMapView!
  let locationManager = CLLocationManager()
  let kJSONRequestURL = "https://api.yelp.com/v2/"
  var businesses: [Business]!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      locationManager.delegate = self
      locationManager.requestAlwaysAuthorization()
      locationManager.requestWhenInUseAuthorization()
      
      if CLLocationManager.locationServicesEnabled() {
        locationManager.startUpdatingLocation()
      }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    mapView.showsUserLocation = (status == .AuthorizedAlways)
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let locValue: CLLocationCoordinate2D = manager.location!.coordinate
    centerMapOnLocation(manager.location!)
    print("your current location is \(locValue.latitude), \(locValue.longitude)")
    search(locValue)
  
    locationManager.stopUpdatingLocation()
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let regionRadius: CLLocationDistance = 1000
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
  func requestData() {
    let url = NSURL(string: kJSONRequestURL)!
    let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
    NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
      
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        hud.hide(true)
        NSLog("Request finished: \(response), error: \(error)")
      })
      
      if self.requestSucceeded(response, error: error) {
        print("success")
      } else {
        let alertController = UIAlertController(title: "Oops!", message: "Network request failed. Check your connection and try again?", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
      }
      
    }).resume()
  }
  
  private func requestSucceeded(response: NSURLResponse!, error: NSError!) -> Bool {
    if let httpResponse = response as? NSHTTPURLResponse {
      return error == nil && httpResponse.statusCode >= 200 && httpResponse.statusCode < 300
    }
    return false
  }
  
  func search(location: CLLocationCoordinate2D) {

    Business.searchWithLocation(location, sort: .Distance, categories: ["icecream"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      
      for business in businesses {
        print(business.name!)
        print(business.address!)
      }
    }
  }
  

}
