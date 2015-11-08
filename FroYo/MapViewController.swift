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
import Social
import Twitter
import Accounts
import MBProgressHUD

class MapViewController: UIViewController, CLLocationManagerDelegate {

  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var froYoSuggestionLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var backButton: UIButton!
  
  @IBOutlet weak var nextButtonLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var backButtonTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var blueRectangleView: UIView!
    @IBOutlet weak var blueRectangleViewWidth: NSLayoutConstraint!
    @IBOutlet weak var blueRectangleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var blueRectangleViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sentLabel: UILabel!
    @IBOutlet weak var sentLabelBottomConstraint: NSLayoutConstraint!
    
  
  let locationManager = CLLocationManager()
  let kJSONRequestURL = "https://api.yelp.com/v2/"
  var selectedSubtitle: String?
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
        
        blueRectangleView.layer.cornerRadius = blueRectangleView.frame.width / 2
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
    
    nextButtonLeadingConstraint.constant = 500
    UIView.animateWithDuration(0.2, animations: {self.view.layoutIfNeeded()}, completion: { (finished: Bool) in
      self.nextButtonLeadingConstraint.constant = 20
    })
    
  }

  @IBAction func previousPlaceButtonAction(sender: AnyObject) {
    updateFroYoAndDistanceLabel(selectBeforeFroYo())
    
    backButtonTrailingConstraint.constant = 500
    UIView.animateWithDuration(0.2, animations: {self.view.layoutIfNeeded()}, completion: { (finished: Bool) in
      self.backButtonTrailingConstraint.constant = 20
    })
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
    
    func animateSentMessage() {
        print("animation started")
        
        blueRectangleView.hidden = false
        blueRectangleViewBottomConstraint.constant = 0
        blueRectangleView.layer.cornerRadius = 0
        blueRectangleViewWidth.constant = self.view.frame.width
        blueRectangleViewHeight.constant = self.view.frame.height
        UIView.animateWithDuration(0.20, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {self.view.layoutIfNeeded()}, completion: { (finished: Bool) in
            
            self.sentLabelBottomConstraint.constant = (self.view.frame.height / 2) - self.sentLabel.frame.height
            UIView.animateWithDuration(0.20, animations: {self.view.layoutIfNeeded()}, completion: { (finished: Bool) in

                self.sentLabelBottomConstraint.constant = (self.view.frame.height / 2)
                UIView.animateWithDuration(0.60, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {self.view.layoutIfNeeded()}, completion: { (finished: Bool) in

                    self.sentLabelBottomConstraint.constant = self.view.frame.height
                    UIView.animateWithDuration(0.20, animations: {self.view.layoutIfNeeded()}, completion: { (finished: Bool) in

                        self.blueRectangleViewBottomConstraint.constant = 20
                        
                        self.blueRectangleView.layer.cornerRadius = 80 / 2
                        self.blueRectangleViewWidth.constant = 80
                        self.blueRectangleViewHeight.constant = 80
                        UIView.animateWithDuration(0.20, animations: {self.view.layoutIfNeeded()}, completion: { (finished: Bool) in
                            
                            self.blueRectangleView.hidden = true
                            self.sentLabelBottomConstraint.constant = -77
                        })
                    })
                })
            })
        })
        
        print("done loading animation")
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
      
      if annotation.subtitle == selectedSubtitle {
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
    selectedSubtitle = business.address!
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
    self.animateSentMessage()
    
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
      granted, error in
      
      if granted {
        print("youre in")
        
        let accountsArray: NSArray = accountStore.accountsWithAccountType(accountType)
        
        if accountsArray.count > 0 {
            let twitterAccount: ACAccount = accountsArray.lastObject as! ACAccount

            let message = ["status" : "Yo froyo at \(self.selectedBusiness!.name!)?\n\(self.returnGoogleAddress(self.selectedBusiness!))"]
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
