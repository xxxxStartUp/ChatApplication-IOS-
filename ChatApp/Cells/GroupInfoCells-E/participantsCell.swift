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
    
    func updateViews(){
        username.GroupInfoPageLabels(type: Constants.groupInfoPage.userNameHeader)
        email.GroupInfoPageLabels(type: Constants.groupInfoPage.emailHeader)
        adminLabel.GroupInfoPageLabels(type: Constants.groupInfoPage.admin)
        
    }
}
