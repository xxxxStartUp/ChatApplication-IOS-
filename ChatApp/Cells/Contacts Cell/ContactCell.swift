//
//  ContactCell.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/21/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var FreindimageView: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    @IBOutlet weak var friendEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var friend : Friend!{
        didSet{
            friendName.text = friend.username
            friendEmail.text = friend.email
            friendName.contactsPageLabels(type: Constants.contactsPage.UserNameHeader)
            friendEmail.contactsPageLabels(type: Constants.contactsPage.emailSubHeader)
        }
    }
    
    
}
