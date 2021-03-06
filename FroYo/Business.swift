//
//  Business.swift
//  FroYo
//
//  Created by Edward Yoo on 11/7/15.
//  Copyright © 2015 EKEY. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Business: NSObject {
  let name: String?
  let address: String?
  let imageURL: NSURL?
  let categories: String?
  let distance: String?
  let ratingImageURL: NSURL?
  let reviewCount: NSNumber?
  let location: NSDictionary?
  let city: String?
  let stateCode: String?

//  let coordinate: NSDictionary?
  
  init(dictionary: NSDictionary) {
    name = dictionary["name"] as? String
    
    let imageURLString = dictionary["image_url"] as? String
    if imageURLString != nil {
      imageURL = NSURL(string: imageURLString!)!
    } else {
      imageURL = nil
    }
    
    location = dictionary["location"] as? NSDictionary
    
    var address = ""
    
    if location != nil {
      let addressArray = location!["address"] as? NSArray
      if addressArray != nil && addressArray!.count > 0 {
        address = addressArray![0] as! String
      }
      
      let neighborhoods = location!["neighborhoods"] as? NSArray
      if neighborhoods != nil && neighborhoods!.count > 0 {
        if !address.isEmpty {
          address += ", "
        }
        address += neighborhoods![0] as! String
      }
    }
    self.address = address
    
    
    self.city = location!["city"] as? String
    self.stateCode = location!["state_code"] as? String
    
    
    let categoriesArray = dictionary["categories"] as? [[String]]
    if categoriesArray != nil {
      var categoryNames = [String]()
      for category in categoriesArray! {
        let categoryName = category[0]
        categoryNames.append(categoryName)
      }
      categories = categoryNames.joinWithSeparator(", ")
    } else {
      categories = nil
    }
    
    let distanceMeters = dictionary["distance"] as? NSNumber
    if distanceMeters != nil {
      let milesPerMeter = 0.000621371
      distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
    } else {
      distance = nil
    }
    
    let ratingImageURLString = dictionary["rating_img_url_large"] as? String
    if ratingImageURLString != nil {
      ratingImageURL = NSURL(string: ratingImageURLString!)
    } else {
      ratingImageURL = nil
    }
    
    reviewCount = dictionary["review_count"] as? NSNumber
  }
  
  class func businesses(array array: [NSDictionary]) -> [Business] {
    var businesses = [Business]()
    for dictionary in array {
      let business = Business(dictionary: dictionary)
      businesses.append(business)
    }
    return businesses
  }
  
  class func searchWithLocation(location: CLLocationCoordinate2D, completion: ([Business]!, NSError!) -> Void) {
    YelpClient.sharedInstance.searchWithLocation(location, completion: completion)
  }
  
  class func searchWithLocation(location: CLLocationCoordinate2D, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([Business]!, NSError!) -> Void) -> Void {
    YelpClient.sharedInstance.searchWithLocation(location, sort: sort, categories: categories, deals: deals, completion: completion)
  }
}