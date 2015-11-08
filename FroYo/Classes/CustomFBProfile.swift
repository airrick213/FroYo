//
//  CustomFBProfile.swift
//  FroYo
//
//  Created by Eric Kim on 11/7/15.
//  Copyright © 2015 EKEY. All rights reserved.
//

import Foundation
import UIKit

class CustomFBProfile {
    
    var userID: String
    var name: String
    var profilePicture: UIImage?
    
    init(userID: String, name: String, pictureURL: String?) {
        self.userID = userID
        self.name = name
        
        if pictureURL != "" && pictureURL != nil {
            self.profilePicture = UIImage(data: NSData(contentsOfURL: NSURL(string: pictureURL!)!)!)!
        }
        else {
            self.profilePicture = nil
        }
    }
    
}
