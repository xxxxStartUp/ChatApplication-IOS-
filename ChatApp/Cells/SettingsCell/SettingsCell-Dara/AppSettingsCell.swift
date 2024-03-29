//
//  AppSettingsCell.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/8/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class AppSettingsCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    func updateViews(indexPath:Int){
        
        switch indexPath {
        case 0:
//            let notifictaion = Notification(name: .displayOn)
//            NotificationCenter.default.post(notifictaion)
            settingsSwitch.tag = 0
            label.text = "Display Mode"
            label.settingsPageLabels(type: Constants.settingsPage.labelTitles)
            if settingsSwitch.isOn{
                
                print("Display mode On")
            }
            else{
                print("Display mode off")
            }
        case 1:
            settingsSwitch.tag = 1
            label.text = "Notification Sound"
            label.settingsPageLabels(type: Constants.settingsPage.labelTitles)
            if settingsSwitch.isOn{
                print("Sound On")
            }
            else{
                print("Sound off")
            }
        default:
            label.text = "Error"
            
            
        }
        
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {

        if settingsSwitch.tag == 0{

     if settingsSwitch.isOn{
         let notifictaion = Notification(name: .displayOn)
         NotificationCenter.default.post(notifictaion)
         Constants.settingsPage.displayModeSwitch = true
         print(Constants.settingsPage.displayModeSwitch)
         
     }
     else{

         let notifictaion = Notification(name: .displayOff)
         NotificationCenter.default.post(notifictaion)
         print("off view")
         Constants.settingsPage.displayModeSwitch = false
         print(Constants.settingsPage.displayModeSwitch)
     }
         
     
 }

        else if(settingsSwitch.tag == 1){
            if settingsSwitch.isOn{
                print("Sound Switch is On")
            }
            else{
                print("Sound Switch is OFF")
            }
        }
    }
    
    
    
}
