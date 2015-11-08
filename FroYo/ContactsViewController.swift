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
import MBProgressHUD
import Foundation
import MessageUI
//import Contacts

class ContactsViewController: UIViewController {
    
    @IBOutlet weak var froyoStoreButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
//    facebook friends
    var friends: [CustomFBProfile] = []
    var userEmail: String?
    var messageSuccess = false
    
//    //contacts
//    let contactStore = CNContactStore()
//    var contacts: [CNContact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFriendsList()
        userEmail = "erickim213@gmail.com"
        
//        if CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts) != CNAuthorizationStatus.Authorized {
//            contactStore.requestAccessForEntityType(CNEntityType.Contacts) { (success: Bool, error: NSError?) -> Void in
//                if error != nil {
//                    AlertHelper.createCancelAlert(title: "Sorry", message: "Could not request contacts", sender: self)
//                }
//                else if success {
//                    self.updateContacts()
//                }
//            }
//        }
//        else {
//            updateContacts()
//        }
    }
    
//    func updateContacts() {
//        do {
//            try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: [CNContactThumbnailImageDataKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey])) { (contact: CNContact, status: UnsafeMutablePointer<ObjCBool>) -> Void in
//                self.contacts.append(contact)
//            }
//            
//            tableView.reloadData()
//        }
//        catch {
//            AlertHelper.createCancelAlert(title: "Sorry", message: "Could not load contacts", sender: self)
//        }
//    }
    
    func sendMessageTo(recipient: String) {
        let message = "Yo froyo?"
        
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients([recipient])
        mailComposeViewController.setMessageBody(message, isHTML: false)
        
        self.presentViewController(mailComposeViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    //MARK: Facebook code
    
    func loadFriendsList() {
        let graphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields" : "email, name, picture"], HTTPMethod: "GET")
        
        graphRequest.startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                AlertHelper.createCancelAlert(title: error.userInfo[FBSDKErrorLocalizedTitleKey] as! String, message: error.userInfo[FBSDKErrorLocalizedDescriptionKey] as! String, sender: self)
            }
            else {
                let resultDict = result as! NSDictionary
                print("Result Dict: \(resultDict)")
                
                let data = resultDict.objectForKey("data") as! NSArray
                
                for i in 0 ..< data.count {
                    let valueDict = data[i] as! NSDictionary
                    let email: String? = valueDict.objectForKey("email") as? String
                    let name = valueDict.objectForKey("name") as! String
                    let pictureData = (valueDict.objectForKey("picture") as! NSDictionary).objectForKey("data") as! NSDictionary
                    let pictureURL: String? = pictureData.objectForKey("url") as? String
                    
                    self.friends.append(CustomFBProfile(email: email, name: name, pictureURL: pictureURL))
                }
                
                self.tableView.reloadData()
                
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
        
//        cell.contact = contacts[indexPath.row]
        
        cell.profile = friends[indexPath.row]
        
        return cell
    }
    
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ContactsTableViewCell
        
        if !cell.cellSelected {
            cell.cellSelected = true
            
            sendMessageTo("KiloCalories")
        }
        
        // text messaging code
        
//        if !cell.cellSelected {
//            let mobileNumbers = cell.contact.phoneNumbers.filter { $0.label == CNLabelPhoneNumberMobile || $0.label == CNLabelPhoneNumberiPhone || $0.label == CNLabelPhoneNumberMain }
//            
//            if mobileNumbers.count > 0 {
//                let mobileNumbersStrings = mobileNumbers.map { ($0.value as! CNPhoneNumber).stringValue }
//                
//                cell.cellSelected = sendMessageTo(mobileNumbersStrings[0])
//            }
//            else {
//                AlertHelper.createCancelAlert(title: "Sorry", message: "No mobile numbers in this contact", sender: self)
//            }
//        }
    }
    
}

extension ContactsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch (result) {
        case MFMailComposeResultCancelled:
            print("Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            print("Mail saved");
            break;
        case MFMailComposeResultSent:
            print("Mail sent");
            break;
        case MFMailComposeResultFailed:
            AlertHelper.createCancelAlert(title: "Sorry", message: "Message failed to send", sender: self)
            break;
        default:
            break;
        }
        
        self.messageSuccess = (result == MFMailComposeResultSent)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

//extension ContactsViewController: MFMessageComposeViewControllerDelegate {
//    
//    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
//        switch result {
//            case MessageComposeResultCancelled:
//                print("Cancelled")
//                break
//            case MessageComposeResultFailed:
//                AlertHelper.createCancelAlert(title: "Sorry", message: "The message failed to send", sender: self)
//                break
//            case MessageComposeResultSent:
//                print("text sent!")
//                break
//            default:
//                break
//        }
//        
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//}
