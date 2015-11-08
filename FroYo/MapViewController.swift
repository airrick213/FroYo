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
import Social
import Twitter
import Accounts


class MapViewController: UIViewController, CLLocationManagerDelegate {

  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var froYoSuggestionLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var backButton: UIButton!
  
  
  
  let locationManager = CLLocationManager()
  let kJSONRequestURL = "https://api.yelp.com/v2/"
  var selectedTitle: String?
  var businesses: [Business]!
  var currentUserLocation: CLLocationCoordinate2D?
  var froYoCounter = 0
  var refreshCounter = 0
  var selectedBusiness: Business?
  
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
    currentUserLocation = manager.location!.coordinate
    print("your current location is \(currentUserLocation!.latitude), \(currentUserLocation!.longitude)")
    searchAndAddAnnotations(currentUserLocation!)
  
    locationManager.stopUpdatingLocation()

  }
  
  func centerMapOnLocation(location: CLLocationCoordinate2D) {
    let regionRadius: CLLocationDistance = 1000
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
  func convertHashLocationToCoordinate(business: Business) -> CLLocationCoordinate2D {
    let locationHash = business.location!
    let coordinateHash = locationHash["coordinate"]!
    let businessLatitude = coordinateHash["latitude"]! as? CLLocationDegrees
    let businessLongitude = coordinateHash["longitude"]! as? CLLocationDegrees
    let businessCoordinate = CLLocationCoordinate2DMake(businessLatitude!, businessLongitude!)
    return businessCoordinate
  }
  
  func searchAndAddAnnotations(location: CLLocationCoordinate2D) {
    Business.searchWithLocation(location, sort: .Distance, categories: nil, deals: false) { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      
      for business in businesses {
        let froYoPlacemark = FroYoPlacemark(title: business.name!, subtitle: business.address!, coordinate: self.convertHashLocationToCoordinate(business), business: business)
        
        self.mapView.addAnnotation(froYoPlacemark)
        if self.refreshCounter == 0 {
          self.updateFroYoAndDistanceLabel(self.initialFroYo())
        }  
      }
    }
  }
  
  @IBAction func nextPlaceButtonAction(sender: AnyObject) {
    updateFroYoAndDistanceLabel(selectNextFroYo())
  }

  @IBAction func previousPlaceButtonAction(sender: AnyObject) {
    updateFroYoAndDistanceLabel(selectBeforeFroYo())
  }

  
  
  func getDistanceInMilesAndUpdateLabel(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) {
    let location1 = CLLocation(latitude: point1.latitude, longitude: point1.longitude)
    let location2 = CLLocation(latitude: point2.latitude, longitude: point2.longitude)
    let distanceInMeters = location2.distanceFromLocation(location1)
    let metersToMilesConversion = 0.000621371
    let distanceInMiles = distanceInMeters * metersToMilesConversion
    let distanceInMilesRounded = round(distanceInMiles * 100.0) / 100.0
    distanceLabel.text = "\(distanceInMilesRounded) Miles away"
  }
  
  func returnGoogleAddress(business: Business) -> String {
    let address = "\(business.address!) \(business.city!) \(business.stateCode!)"
    let addressNoCommas = address.stringByReplacingOccurrencesOfString(",", withString: "")
    let urlAddress = addressNoCommas.stringByReplacingOccurrencesOfString(" ", withString: "+")
    
    print(business.city!)
    return("https://www.google.com/maps/place/\(urlAddress)")
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
      
      if annotation.title == selectedTitle {
        view.pinTintColor = UIColor.greenColor()
      } else {
        view.pinTintColor = UIColor.redColor()
      }
      return view
    }
    return nil
  }
  
  func initialFroYo() -> Business {
    backButton.enabled = false
    selectedBusiness = businesses[froYoCounter]
    return businesses[froYoCounter]
  }
  
  func selectNextFroYo() -> Business {
    froYoCounter += 1
    selectedBusiness = businesses[froYoCounter]
    return businesses[froYoCounter]
  }
  
  func selectBeforeFroYo() -> Business {
    froYoCounter -= 1
    nextButton.enabled = true
    selectedBusiness = businesses[froYoCounter]
    return businesses[froYoCounter]
  }
  
  func checkButtonEnabling() {
    if froYoCounter <= 0 {
      backButton.enabled = false
    }
    
    if froYoCounter > 0 {
      backButton.enabled = true
    }
    
    if froYoCounter == businesses.count - 1 {
      nextButton.enabled = false
    }
    
  }
  
  func updateFroYoAndDistanceLabel(business: Business) {
    froYoSuggestionLabel.text = "\(business.name!)"
    selectedTitle = business.name!
    let businessPinArray = mapView.annotations
    mapView.removeAnnotations(businessPinArray)
    mapView.addAnnotations(businessPinArray)
    centerMapOnLocation(convertHashLocationToCoordinate(business))
    getDistanceInMilesAndUpdateLabel(currentUserLocation!, point2: convertHashLocationToCoordinate(business))
    checkButtonEnabling()
    print(returnGoogleAddress(business))
  }
  
  func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
    let selectedAnnotation = view.annotation as? FroYoPlacemark
    
    for business in businesses {
      if selectedAnnotation!.subtitle! == business.address! {
        let indexNumber = businesses.indexOf(business)
        froYoCounter = indexNumber!
      }
    }
    selectedBusiness = businesses[froYoCounter]
    updateFroYoAndDistanceLabel(selectedAnnotation!.business!)
  }
  
  
  // MARK: Tweet
  
  @IBAction func tweetButtonAction(sender: AnyObject) {
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
      granted, error in
      
      if granted {
        print("youre in")
        let accountsArray: NSArray = accountStore.accountsWithAccountType(accountType)
        
        if accountsArray.count > 0 {
          let twitterAccount: ACAccount = accountsArray.lastObject as! ACAccount

            let message = ["status" : "Yo froyo?\n\(self.returnGoogleAddress(self.selectedBusiness!))"]
            let requestURL = NSURL(string:
              "https://api.twitter.com/1.1/statuses/update.json")
          
            let postRequest = SLRequest(forServiceType:
              SLServiceTypeTwitter,
              requestMethod: SLRequestMethod.POST,
              URL: requestURL,
              parameters: message)
          postRequest.account = twitterAccount
          
          postRequest.performRequestWithHandler({
            (responseData: NSData!,
            urlResponse: NSHTTPURLResponse!,
            error: NSError!) -> Void in
            
            if let err = error {
              print("Error : \(err.localizedDescription)")
            }
            print("Twitter HTTP response \(urlResponse.statusCode)")
          })
          
          }
      } else {
        print("no")
      }
    
    }
    
    
//    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
//      let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//      tweetSheet.setInitialText("Yo froyo?\n\(returnGoogleAddress(selectedBusiness!))")
//      self.presentViewController(tweetSheet, animated: true, completion: nil)
//    } else {
//      print("error")
//    }
  }
  
}
