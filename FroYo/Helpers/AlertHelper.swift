//
//  AlertHelper.swift
//  FroYo
//
//  Created by Eric Kim on 11/7/15.
//  Copyright © 2015 EKEY. All rights reserved.
//

import UIKit
import Foundation

class AlertHelper {
    
    internal static func createCancelAlert(title title: String, message: String, sender: UIViewController) {
        let actionController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action: UIAlertAction) -> Void in
            actionController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        actionController.addAction(cancelAction)
        
        sender.showViewController(actionController, sender: sender)
    }
    
}
