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
    
    func updateViews(indexPath:Int){

        switch indexPath {
        case 0:
            label.text = "Display Mode"
        case 1:
            label.text = "Sound"
        default:
            label.text = "Error"
        }
        
        
        
    }
    
}
