//
//  NotificationsCell.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/6/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var notificationMessageLabel: UILabel!
    @IBOutlet weak var notificationMarker: UIImageView!
    
    func updateViews(){
        
        timeStampLabel.text = "10/22/1996"
        timeStampLabel.notificationsPageLabels(type: Constants.notificationPage.timeStampHeader)
        notificationMessageLabel.notificationsPageLabels(type:Constants.notificationPage.notificationMessage)
        notificationMessageLabel.text = "Dara just left the chat"
    }

}
