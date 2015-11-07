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


class MapViewController: UIViewController, CLLocationManagerDelegate {

  @IBOutlet weak var mapView: MKMapView!
  let locationManager = CLLocationManager()
  let kJSONRequestURL = "https://api.yelp.com/v2/"
  var businesses: [Business]!
//  var businessCoordinate: CLLocationCoordinate2D
  
    override func viewDidLoad() {
      super.viewDidLoad()
      locationManager.delegate = self
      mapView.delegate = self
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
    searchAndAddAnnotations(locValue)
  
    locationManager.stopUpdatingLocation()
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let regionRadius: CLLocationDistance = 1000
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
  func searchAndAddAnnotations(location: CLLocationCoordinate2D) {
    Business.searchWithLocation(location, sort: .Distance, categories: nil, deals: false) { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      
      for business in businesses {
        let locationHash = business.location!
        let coordinateHash = locationHash["coordinate"]!
        let businessLatitude = coordinateHash["latitude"]! as? CLLocationDegrees
        let businessLongitude = coordinateHash["longitude"]! as? CLLocationDegrees
        
        let businessCoordinate = CLLocationCoordinate2DMake(businessLatitude!, businessLongitude!)
        print(businessCoordinate)
        
        let froYoPlacemark = FroYoPlacemark(title: business.name!, subtitle: business.address!, coordinate: businessCoordinate)
        self.mapView.addAnnotation(froYoPlacemark)
      }
    }
  }
  
  
  
}

extension MapViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if let annotation = annotation as? FroYoPlacemark {
      let identifier = "pin"
      var view: MKPinAnnotationView
      if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        as? MKPinAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
      } else {
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
      }
      return view
    }
    return nil
  }
}
