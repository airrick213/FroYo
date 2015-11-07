//
//  ContactsViewController.swift
//  FroYo
//
//  Created by Eric Kim on 11/7/15.
//  Copyright © 2015 EKEY. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKMessengerShareKit
import MBProgressHUD
import Foundation
import Alamofire
import SwiftyJSON

class ContactsViewController: UIViewController {
    
    @IBOutlet weak var froyoStoreButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var friends: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFriendsList()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFriendsList() {
        let graphRequest = FBSDKGraphRequest.init(graphPath: "friends", parameters: ["fields" : "id, name, picture"], HTTPMethod: "GET")
        
        graphRequest.startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                let actionController = UIAlertController(title: "Sorry", message: "Could not load friends list", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action: UIAlertAction) -> Void in
                    actionController.dismissViewControllerAnimated(true, completion: nil)
                }
                
                actionController.addAction(cancelAction)
                
                self.showViewController(actionController, sender: self)
            }
            else {
                let resultDict = result as! NSDictionary
                print("Result Dict: \(resultDict)")
                
                self.friends = resultDict.objectForKey("data") as! NSArray
                
                for i in 0 ..< self.friends.count {
                    let valueDict = self.friends[i] as! NSDictionary
                    let id = valueDict.objectForKey("id") as! String
                    print("the id value is \(id)")
                }
                
                print("Found \(self.friends.count) friends")
            }
        }
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

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactsTableViewCell
        
        return cell
    }
    
}
