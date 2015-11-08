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
    

    override func viewDidLoad() {
        super.viewDidLoad()
  }
    
  

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


