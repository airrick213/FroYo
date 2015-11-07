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
    @IBOutlet weak var sentLabel: UILabel!
    @IBOutlet weak var greenViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var greenViewWidth: [NSLayoutConstraint]!
    
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
        
        sentLabel.hidden = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            animateSend()
            nameLabel.textColor = UIColor(red: 164.0/255.0, green: 231.0/255.0, blue: 134.0/255.0, alpha: 1.0)
        }
    }
    
    func animateSend() {
        print("text sent!")
        
//        sentLabel.hidden = false
//        
//        UIView.animateWithDuration(1) { () -> Void in
//            self.greenViewWidth[0].constant = self.contentView.frame.width
//        }
//        self.layoutIfNeeded()
//        
//        UIView.animateWithDuration(1) { () -> Void in
//            self.greenViewLeadingConstraint.constant = self.contentView.frame.width
//        }
//        self.layoutIfNeeded()
//        
//        sentLabel.hidden = true
    }

}
