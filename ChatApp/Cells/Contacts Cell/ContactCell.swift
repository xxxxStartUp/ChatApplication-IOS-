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
    
    @IBOutlet weak var freindLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var friend : Friend!{
        didSet{
            friendName.text = friend.username
            freindLocation.text = friend.email
        }
    }
    
    
}
