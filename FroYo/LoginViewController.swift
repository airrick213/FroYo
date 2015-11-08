//
//  LoginViewController.swift
//  FroYo
//
//  Created by Eric Kim on 11/7/15.
//  Copyright © 2015 EKEY. All rights reserved.
//

import UIKit
import TwitterKit


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
      logInButton.center = self.view.center
      self.view.addSubview(logInButton)

    }
  
  override func viewDidAppear(animated: Bool) {
    if Twitter.sharedInstance().session() != nil {
      self.presentMapViewController()
    }
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

