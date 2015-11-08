//
//  LoginViewController.swift
//  FroYo
//
//  Created by Eric Kim on 11/7/15.
//  Copyright © 2015 EKEY. All rights reserved.
//

import UIKit
import TwitterKit
import Foundation
import QuartzCore

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      print(Twitter.sharedInstance().session())
      let logInButton = TWTRLogInButton { (session, error) in
        if let unwrappedSession = session {
          let alert = UIAlertController(title: "Logged In",
            message: "User \(unwrappedSession.userName) has logged in",
            preferredStyle: UIAlertControllerStyle.Alert
          )
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
          self.presentMapViewController()
        } else {
          NSLog("Login error: %@", error!.localizedDescription);
        }
      }
      
      // TODO: Change where the log in button is positioned in your view
      logInButton.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 60)
        self.view.addSubview(logInButton)

    }
  
  override func viewDidAppear(animated: Bool) {
    if Twitter.sharedInstance().session() != nil {
      self.presentMapViewController()
    }
  }
    
    override func viewWillAppear(animated: Bool) {
        let backgroundGradientLayer = makeGradient()
        backgroundGradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(backgroundGradientLayer, atIndex: 0)
    }

    func makeGradient() -> CAGradientLayer {
        //pink
//        let color1 = UIColor(red: 1.0, green: 240.0/255.0, blue: 245.0/255.0, alpha: 1.0)
//        let color2 = UIColor(red: 1.0, green: 221.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        
        //white and silver
        let color1 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let color2 = UIColor(red: 200.0/255.0, green: 210.0/255.0, blue: 215.0/255.0, alpha: 1.0)
        
        let colors = [color1.CGColor, color2.CGColor]
        
        let locations = [NSNumber(double: 0), NSNumber(double: 1.0)]
        
        let headerLayer = CAGradientLayer()
        headerLayer.colors = colors as [AnyObject]
        headerLayer.locations = locations
        
        return headerLayer
    }
  
    func presentMapViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        
        self.presentViewController(mapViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

