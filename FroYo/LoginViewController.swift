//
//  LoginViewController.swift
//  FroYo
//
//  Created by Eric Kim on 11/7/15.
//  Copyright © 2015 EKEY. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  override func viewDidAppear(animated: Bool) {
    if FBSDKAccessToken.currentAccessToken() != nil {
      presentContactsViewController()
    }
    else {
      let loginButton: FBSDKLoginButton = FBSDKLoginButton.init()
      
      loginButton.center = self.view.center
      loginButton.readPermissions = ["public_profile", "email", "user_friends"]
      loginButton.delegate = self
      
      self.view.addSubview(loginButton)
    }
  }
  
    func presentContactsViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactsViewController = storyboard.instantiateViewControllerWithIdentifier("ContactsViewController") as! ContactsViewController
        
        self.presentViewController(contactsViewController, animated: true, completion: nil)
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

extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            print(error)
        }
        else if !result.isCancelled {
            presentContactsViewController()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        return
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
}
