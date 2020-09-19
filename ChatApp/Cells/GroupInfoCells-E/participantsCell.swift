//
//  participantsCell.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class participantsCell: UITableViewCell {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var adminLabel: UILabel!

    
    
    func updateViews(groupParticipants:[Friend],indexPath:Int,group:Group){
        username.GroupInfoPageLabels(type: Constants.groupInfoPage.userNameHeader)
        email.GroupInfoPageLabels(type: Constants.groupInfoPage.emailHeader)
        adminLabel.GroupInfoPageLabels(type: Constants.groupInfoPage.admin)
        if !groupParticipants.isEmpty{
        username.text = groupParticipants[indexPath].username
        email.text = groupParticipants[indexPath].email

        
            if group.GroupAdmin.email == groupParticipants[indexPath].email{
                adminLabel.text = "Admin"
            }
            else{
                adminLabel.text = ""
            }
        }
        else{
        username.text = ""
        email.text = ""
        adminLabel.text = ""
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
