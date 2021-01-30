//
//  GroupSettingCell.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class GroupSettingCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var settingsSwitch: UISwitch!
    func updateViews(indexPath:Int){
        
        switch indexPath {
        case 0:
            //            let notifictaion = Notification(name: .displayOn)
            //            NotificationCenter.default.post(notifictaion)
            settingsSwitch.tag = 0
            label.text = "Mute"
            label.GroupInfoPageLabels(type: Constants.groupInfoPage.settingsHeader)
            if settingsSwitch.isOn{
                
                print("Display mode On")
            }
            else{
                print("Display mode off")
            }
//        case 1:
//            settingsSwitch.tag = 1
//            label.text = "Archive"
//            label.GroupInfoPageLabels(type: Constants.groupInfoPage.settingsHeader)
//            if settingsSwitch.isOn{
//
//            }
//            else{
//
//            }
        default:
            label.text = "Error"
            
            
        }
        
    }
    
}
