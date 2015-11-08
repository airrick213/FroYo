//
//  YelpClient.swift
//  FroYo
//
//  Created by Edward Yoo on 11/7/15.
//  Copyright © 2015 EKEY. All rights reserved.
//

import Foundation
import UIKit
import BDBOAuth1Manager
import AFNetworking
import CoreLocation

let yelpConsumerKey = "o6uTV-rkbytxUnesk0DTzw"
let yelpConsumerSecret = "Ais1p2L42JBeH9mhKLE49-hTyXE"
let yelpToken = "6e5kGqVMtfcf-E-liY8w2P-Ev9cbKXri"
let yelpTokenSecret = "8VY9zeV3bOR5R1HNIJ1FLW3YcZQ"

enum YelpSortMode: Int {
  case BestMatched = 0, Distance, HighestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {
  var accessToken: String!
  var accessSecret: String!
  
  class var sharedInstance : YelpClient {
    struct Static {
      static var token : dispatch_once_t = 0
      static var instance : YelpClient? = nil
    }
    
    dispatch_once(&Static.token) {
      Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    }
    return Static.instance!
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
    self.accessToken = accessToken
    self.accessSecret = accessSecret
    let baseUrl = NSURL(string: "https://api.yelp.com/v2/")
    super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
    
    let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
    self.requestSerializer.saveAccessToken(token)
  }
  
  func searchWithLocation(location: CLLocationCoordinate2D, completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
    return searchWithLocation(location, sort: nil, categories: nil, deals: nil, completion: completion)
  }
  
  func searchWithLocation(location: CLLocationCoordinate2D, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
    
    // Default the location to San Francisco
    var parameters: [String : AnyObject] = ["term": "frozen yogurt", "ll": "\(location.latitude),\(location.longitude)"]
    
    if sort != nil {
      parameters["sort"] = sort!.rawValue
    }
    
    if categories != nil && categories!.count > 0 {
      parameters["category_filter"] = (categories!).joinWithSeparator(",")
    }
    
    if deals != nil {
      parameters["deals_filter"] = deals!
    }
    
    print(parameters)
    
    return self.GET("search", parameters: parameters, success: {
      (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        let dictionaries = response["businesses"] as? [NSDictionary]
      if dictionaries != nil {
        completion(Business.businesses(array: dictionaries!), nil)
      }
      }, failure: nil)!
    

  }
}
