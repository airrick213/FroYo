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
    
    var email: String?
    var name: String
    var profilePicture: UIImage?
    
    init(email: String?, name: String, pictureURL: String?) {
        self.email = email
        self.name = name
        
        if pictureURL != "" && pictureURL != nil {
            self.profilePicture = UIImage(data: NSData(contentsOfURL: NSURL(string: pictureURL!)!)!)!
        }
        else {
            self.profilePicture = nil
        }
    }
    
}
