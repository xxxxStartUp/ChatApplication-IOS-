//
//  participantsHeaderCell.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/20/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class participantsHeaderCell: UITableViewCell {

    @IBOutlet weak var groupMembersLabel: UILabel!
    
    func updateviews(){
        groupMembersLabel.text = "Group Members"
        groupMembersLabel.GroupInfoPageLabels(type: Constants.groupInfoPage.groupMemberTitleHeader)
    }
    
}
