//
//  ContactsTableViewCell.swift
//  FroYo
//
//  Created by Eric Kim on 11/7/15.
//  Copyright © 2015 EKEY. All rights reserved.
//

import UIKit
import Contacts

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var contact: CNContact! {
        didSet {
            if let imageData = contact.thumbnailImageData {
                profileImageView.image = UIImage(data: imageData)
            }
            else {
                profileImageView.image = UIImage(named: "ContactIcon")
            }
            
            nameLabel.text = contact.givenName + " " + contact.familyName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
