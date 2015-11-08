//
//  FroYoPlacemark.swift
//  FroYo
//
//  Created by Edward Yoo on 11/7/15.
//  Copyright © 2015 EKEY. All rights reserved.
//

import Foundation
import MapKit

class FroYoPlacemark: NSObject, MKAnnotation {
  let title: String?
  let subtitle: String?
  let froYoCoordinate: CLLocationCoordinate2D?
  let business: Business?
  
  init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, business: Business) {
    self.title = title
    self.subtitle = subtitle
    self.froYoCoordinate = coordinate
    self.business = business
    
    super.init()
  }
  
  var coordinate: CLLocationCoordinate2D {
    return froYoCoordinate!
  }

  
}