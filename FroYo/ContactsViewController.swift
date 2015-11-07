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
import Contacts

class ContactsViewController: UIViewController {
    
    @IBOutlet weak var froyoStoreButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
////    facebook friends
//    var friends: NSArray = []
    
    //contacts
    let contactStore = CNContactStore()
    var contacts: [CNContact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadFriendsList()
        
        if CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts) != CNAuthorizationStatus.Authorized {
            contactStore.requestAccessForEntityType(CNEntityType.Contacts) { (success: Bool, error: NSError?) -> Void in
                if error != nil {
                    AlertHelper.createCancelAlert(title: "Sorry", message: "Could not request contacts", sender: self)
                }
                else if success {
                    self.updateContacts()
                }
            }
        }
        else {
            updateContacts()
        }
    }
    
    func updateContacts() {
        do {
            try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: [CNContactThumbnailImageDataKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey])) { (contact: CNContact, status: UnsafeMutablePointer<ObjCBool>) -> Void in
                self.contacts.append(contact)
            }
            
            tableView.reloadData()
        }
        catch {
            AlertHelper.createCancelAlert(title: "Sorry", message: "Could not load contacts", sender: self)
        }
    }
    
    
    
    
    
    
    
    //MARK: Facebook code
    
    
//    func loadFriendsList() {
//        let graphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields" : "id"], HTTPMethod: "GET")
//        
//        graphRequest.startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
//            if error != nil {
//                let actionController = UIAlertController(
//                    title: error.userInfo[FBSDKErrorLocalizedTitleKey] as? String,
//                    message: error.userInfo[FBSDKErrorLocalizedDescriptionKey] as? String,
//                    preferredStyle: UIAlertControllerStyle.Alert)
//                
//                let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action: UIAlertAction) -> Void in
//                    actionController.dismissViewControllerAnimated(true, completion: nil)
//                }
//                
//                actionController.addAction(cancelAction)
//                
//                self.showViewController(actionController, sender: self)
//            }
//            else {
//                let resultDict = result as! NSDictionary
//                print("Result Dict: \(resultDict)")
//                
//                self.friends = resultDict.objectForKey("data") as! NSArray
//                
//                for i in 0 ..< self.friends.count {
//                    let valueDict = self.friends[i] as! NSDictionary
//                    let id = valueDict.objectForKey("id") as! String
//                    print("the id value is \(id)")
//                }
//                
//                print("Found \(self.friends.count) friends")
//            }
//        }
//    }
    

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
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactsTableViewCell
        
        cell.contact = contacts[indexPath.row]
        
        return cell
    }
    
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactsTableViewCell
        
        if !cell.selected {
            cell.selected = true
        }
    }
    
}
